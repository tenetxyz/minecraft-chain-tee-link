package net.tenet.simulatorplugin;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.apache.commons.lang3.tuple.Pair;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.plugin.Plugin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Map;
import java.util.function.BiPredicate;
import java.util.stream.Collectors;


class ActivateCreationHandler implements HttpHandler {
    Plugin pluginReference; // This reference helps us modify the world on the main thread via a bukkit scheduler
    Map<String, Creation> creations; // maps creationId -> Creation. We update this after a creation is activated

    public ActivateCreationHandler(Plugin pluginReference, Map<String, Creation> creations) {
        this.pluginReference = pluginReference;
        this.creations = creations;
    }

    public void handle(HttpExchange exchange) throws IOException {
        Pair<Integer, String> responsePair = tryActivateCreation(exchange);
        int statusCode = responsePair.getLeft();
        String response = responsePair.getRight();

        System.out.println(response);
        byte[] responseBytes = response.getBytes();
        exchange.sendResponseHeaders(statusCode, responseBytes.length);
        OutputStream os = exchange.getResponseBody();
        os.write(responseBytes);
        os.close();
    }

    // returns the statusCode and the response
    private Pair<Integer, String> tryActivateCreation(HttpExchange exchange) {
        Creation creation;
        try {
            String requestBody = new BufferedReader(new InputStreamReader(exchange.getRequestBody()))
                    .lines().collect(Collectors.joining("\n"));
            Gson gson = new Gson();
            creation = gson.fromJson(requestBody, Creation.class);
        } catch (Exception e) {
            return Pair.of(400, "Could not parse request body: " + e.getMessage());
        }

        // validate creation
        if (creation.ownerPlayerId == null || creation.ownerPlayerId.isEmpty()) {
            return Pair.of(400, "No ownerPlayerId provided. Creations must have an ownerPlayerId.");
        }
        if (creation.creationId == null || creation.creationId.isEmpty()) {
            return Pair.of(400, "No creationId provided. Creations must have a creationId.");
        }
        if (creation.blocks.length == 0) {
            return Pair.of(400, "No blocks provided. Creations must have at least one block.");
        }
        if (!creationHasStorageBlocks(creation)) {
            return Pair.of(400, "No storage blocks found. Creations must have at least one storage block.");
        }

        try {
            setCreation(creation);
            creation.upperNorthEastBlock = calculateCornerBlock(creation.blocks, (Block block, Block resultBlock) ->
                    block.x >= resultBlock.x &&
                            block.y >= resultBlock.y &&
                            block.z >= resultBlock.z);
            creation.lowerSouthwestBlock = calculateCornerBlock(creation.blocks, (Block block, Block resultBlock) ->
                    block.x <= resultBlock.x &&
                            block.y <= resultBlock.y &&
                            block.z <= resultBlock.z);
            creations.put(creation.creationId, creation);

            return Pair.of(200, String.format("Creation with id=%s activated!", creation.creationId));
        } catch (Exception e) {
//            e.printStackTrace();
            return Pair.of(400, "Could not activate creation: " + e.getMessage());
        }
    }

    private static Block calculateCornerBlock(Block[] blocks, BiPredicate<Block, Block> evaluationFunction) {
        Block resultBlock = blocks[0];

        for (Block block : blocks) {
            if (evaluationFunction.test(block, resultBlock)) {
                resultBlock = block;
            }
        }

        return resultBlock;
    }

    private void setCreation(Creation creation) throws IllegalArgumentException {
        // we can only modify the world on the main bukkit thread. so use a bukkit scheduler
        World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
        Bukkit.getScheduler().runTask(pluginReference, () -> {
            for (Block block : creation.blocks) {
                Material material = Material.matchMaterial(block.blockMaterial);
                if (material == null) {
                    throw new IllegalArgumentException("Invalid material " + block.blockMaterial);
                }
                world.getBlockAt(block.x, block.y, block.z).setType(material, true);
            }
        });
    }

    private boolean creationHasStorageBlocks(Creation creation) {
        for (Block block : creation.blocks) {
            if (block.blockMaterial.equalsIgnoreCase("chest"))
                return true;
        }
        return false;
    }
}
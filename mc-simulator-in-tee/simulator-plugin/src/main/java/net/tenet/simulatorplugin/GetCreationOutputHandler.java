package net.tenet.simulatorplugin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.apache.commons.lang3.tuple.Pair;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.block.Chest;
import org.bukkit.inventory.Inventory;
import org.bukkit.inventory.ItemStack;
import org.bukkit.plugin.Plugin;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

public class GetCreationOutputHandler implements HttpHandler {
    Plugin pluginReference; // This reference helps us modify the world on the main thread via a bukkit scheduler
    Map<String, Creation> creations; // maps creationId -> Creation. We update this after a creation is activated

    public GetCreationOutputHandler(Plugin pluginReference, Map<String, Creation> creations) {
        this.pluginReference = pluginReference;
        this.creations = creations;
    }


    @Override
    public void handle(HttpExchange exchange) throws IOException {
        Pair<Integer, String> responsePair = tryGetCreationOutput(exchange);
        int statusCode = responsePair.getLeft();
        String response = responsePair.getRight();
        byte[] responseBytes = response.getBytes();
        exchange.sendResponseHeaders(statusCode, responseBytes.length);
        exchange.getResponseBody().write(responseBytes);
        exchange.getResponseBody().close();
    }

    private Pair<Integer, String> tryGetCreationOutput(HttpExchange exchange) {
        GetCreationOutputRequest getCreationOutputRequest;
        try {
            String requestBody = new BufferedReader(new InputStreamReader(exchange.getRequestBody()))
                    .lines().collect(Collectors.joining("\n"));
            Gson gson = new Gson();
            getCreationOutputRequest = gson.fromJson(requestBody, GetCreationOutputRequest.class);
        } catch (Exception e) {
            return Pair.of(400, "Could not parse request body: " + e.getMessage());
        }
        Creation creation = creations.get(getCreationOutputRequest.creationId);
        if (creation == null) {
            return Pair.of(400, "Could not find creation with id=" + getCreationOutputRequest.creationId);
        }

        try {
            // Since we are in the api server's handler, we are NOT in the main java thread
            // So when calling the bukkit methods, we need to use the bukkit scheduler, and use a future to get the result back
            CompletableFuture<String> future = new CompletableFuture<>();
            Bukkit.getScheduler().runTask(pluginReference, () -> {
                List<org.bukkit.block.Block> storageBlocks = getStorageBlocksInRegion(creation);
                String storageItemsAsJson = getStorageItemsAsJson(storageBlocks);
                future.complete(storageItemsAsJson);
            });
            String creationOutput = future.get(); // wait for the bukkit thread to finish
            return Pair.of(200, creationOutput);
        } catch (Exception e) {
            e.printStackTrace();
            return Pair.of(400, "Could not get creation output: " + e.getMessage());
        }
    }

    // PERF: if we want to optimize this, we can precalculate the storage blocks in the region
    // Note: Shulker boxes are problematic because they can break after placing them AND they can be placed by
    // dispensers so we can't precalculate the storage blocks if we allow shulkers
    private List<org.bukkit.block.Block> getStorageBlocksInRegion(Creation creation) {
        ArrayList<org.bukkit.block.Block> storageBlocks = new ArrayList<>();

        World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
        for (Block creationBlock : creation.blocks) {
            org.bukkit.block.Block bukkitBlock = world.getBlockAt(creationBlock.x, creationBlock.y, creationBlock.z);
            if (bukkitBlock.getType() == Material.CHEST) {
                storageBlocks.add(bukkitBlock);
            }
        }
        return storageBlocks;
    }

    // Note: If the farm drops loot with NBT data (enchanted golden swords at 50% durability), the output would still be GOLDEN_SWORD
    // I think this is fine if we forget about the nbt data. These are just item farms
    // - NBT = named binary tag. It's just item metadata
    private String getStorageItemsAsJson(List<org.bukkit.block.Block> storageBlocks) {
        Gson gson = new Gson();
        Map<String, Integer> items = new HashMap<>();

        for (org.bukkit.block.Block block : storageBlocks) {
            if (block.getState() instanceof Chest) { // getState requires synchronous access to the main thread. So this function needs to be in a schedular
                Chest chest = (Chest) block.getState();
                Inventory inventory = chest.getBlockInventory();

                for (ItemStack itemStack : inventory.getContents()) {
                    if (itemStack != null) {
                        String itemName = itemStack.getType().name();
                        int amount = itemStack.getAmount();
                        items.put(itemName, items.getOrDefault(itemName, 0) + amount);
                    }
                }
            }
        }

        // convert the items map to json
        JsonObject jsonObject = new JsonObject();
        for (Map.Entry<String, Integer> item : items.entrySet()) {
            jsonObject.addProperty(item.getKey(), item.getValue());
        }

        return jsonObject.toString();
    }
}

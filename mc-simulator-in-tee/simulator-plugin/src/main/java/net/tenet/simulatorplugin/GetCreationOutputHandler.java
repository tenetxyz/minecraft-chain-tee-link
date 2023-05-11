package net.tenet.simulatorplugin;

import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.World;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class GetCreationOutputHandler implements HttpHandler {
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        String requestBody = new BufferedReader(new InputStreamReader(exchange.getRequestBody()))
                .lines().collect(Collectors.joining("\n"));
        Gson gson = new Gson();
        Creation creation = gson.fromJson(requestBody, Creation.class);

        List<org.bukkit.block.Block> storageBlocks = getStorageBlocksInRegion(creation);

        exchange.sendResponseHeaders(200, 0);
        String response = "Request processed successfully";
        exchange.getResponseBody().write(response.getBytes());
        exchange.getResponseBody().close();
    }

    // PERF: if we want to optimize this, we can precalculate the storage blocks in the region
    // Note: Shulker boxes are problematic because they can break after placing them AND they can be placed by
    // dispensers so we can't precalculate the storage blocks if we allow shulkers
    private List<org.bukkit.block.Block> getStorageBlocksInRegion(Creation creation) {
        ArrayList<org.bukkit.block.Block> storageBlocks = new ArrayList<>();

        World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
        int minX = creation.lowerSouthwestBlock.x;
        int minY = creation.lowerSouthwestBlock.y;
        int minZ = creation.lowerSouthwestBlock.z;
        int maxX = creation.upperNorthEastBlock.x;
        int maxY = creation.upperNorthEastBlock.y;
        int maxZ = creation.upperNorthEastBlock.z;

        for (int x = minX; x <= maxX; x++) {
            for (int y = minY; y <= maxY; y++) {
                for (int z = minZ; z <= maxZ; z++) {
                    org.bukkit.block.Block block = world.getBlockAt(x, y, z);
                    if (block.getType() == Material.CHEST) {
                        storageBlocks.add(block);
                    }
                }
            }
        }
        return storageBlocks;
    }
}

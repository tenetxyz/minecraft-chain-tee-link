package net.tenet.simulatorplugin;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.plugin.Plugin;

import java.io.*;
import java.util.stream.Collectors;

class ActivateCreationHandler implements HttpHandler {
    Plugin pluginReference; // This reference helps us modify the world on the main thread via a bukkit scheduler

    public ActivateCreationHandler(Plugin pluginReference) {
        this.pluginReference = pluginReference;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        String requestBody = new BufferedReader(new InputStreamReader(exchange.getRequestBody()))
                .lines().collect(Collectors.joining("\n"));
        Gson gson = new Gson();
        ActivateCreationRequest activateCreationRequest = gson.fromJson(requestBody, ActivateCreationRequest.class);

        String response;
        int statusCode;
        try {
            setCreation(activateCreationRequest);
            response = "Creation activated!";
            statusCode = 200;
        } catch (Exception e) {
            response = "Could not activate creation. " + e.getMessage();
            statusCode = 400;
        }
        System.out.println(response);
        exchange.sendResponseHeaders(statusCode, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }

    private void setCreation(ActivateCreationRequest activateCreationRequest ) throws IllegalArgumentException{
        // we can only modify the world on the main bukkit thread. so use a bukkit scheduler
        World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
        Bukkit.getScheduler().scheduleSyncRepeatingTask(pluginReference, () -> {
            for (Block block : activateCreationRequest.blocks) {
                Material material = Material.matchMaterial(block.blockMaterial);
                if (material == null) {
                    throw new IllegalArgumentException("Invalid material " + block.blockMaterial);
                }
                world.getBlockAt(block.x, block.y, block.z).setType(material, true);
            }
        }, 20, 20);
    }
}
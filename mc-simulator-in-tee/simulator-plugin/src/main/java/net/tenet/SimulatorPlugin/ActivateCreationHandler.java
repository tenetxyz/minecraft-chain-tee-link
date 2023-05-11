package net.tenet.SimulatorPlugin;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.bukkit.Bukkit;
import org.bukkit.Material;
import org.bukkit.World;

import java.io.*;
import java.util.stream.Collectors;

class ActivateCreationHandler implements HttpHandler {
    // TODO: implement this
    @Override
    public void handle(HttpExchange exchange) throws IOException {
        // Read the JSON payload from the request
        String requestBody = new BufferedReader(new InputStreamReader(exchange.getRequestBody()))
                .lines().collect(Collectors.joining("\n"));

        // Parse the JSON payload using Gson
        Gson gson = new Gson();
        ActivateCreationRequest activateCreationRequest = gson.fromJson(requestBody, ActivateCreationRequest.class);

        String response = "Creation activated!";
        try{
            setCreation(activateCreationRequest);
        }catch(NullPointerException e){
            response =  "Could not activate creation. " + e.getMessage();
            exchange.sendResponseHeaders(400, response.length());
        }
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }

    private void setCreation(ActivateCreationRequest activateCreationRequest ) {
            World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
        for(Block block : activateCreationRequest.blocks){
            Material material = Material.matchMaterial(block.blockMaterial);
            if(material == null){
                throw new IllegalArgumentException("Invalid material " + block.blockMaterial);
            }
            world.getBlockAt(block.x, block.y, block.z).setType(material, true);
        }
        System.out.println("Creation has been activated!");
    }
}
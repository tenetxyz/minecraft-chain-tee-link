package net.tenet.SimulatorPlugin;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import org.bukkit.Bukkit;
import org.bukkit.Chunk;
import org.bukkit.World;
import com.google.gson.Gson;

import java.io.*;

class ActivateCreationHandler implements HttpHandler {
    // TODO: implement this
    @Override
    public void handle(HttpExchange exchange) throws IOException {

        // Bukkit.getScheduler().runTaskAsynchronously(this, () -> overwriteChunks(chunkDataFile));
        int contentLength = Integer.parseInt(exchange.getRequestHeaders().getFirst("content-length"));
        byte[] buffer = new byte[contentLength];

        try {
            String data = new String(Files.readAllBytes(f.toPath()));
            Gson gson = new Gson();
            this.serverMetadata = gson.fromJson(data, ServerMetadata.class);
            System.out.println("Loaded server metadata from file.");
        } catch (IOException e) {
            System.out.println("Failed to load server metadata from file!");
            e.printStackTrace();
        }

        exchange.getRequestBody().read(buffer, 0, contentLength);
        ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
        ObjectInputStream ois = new ObjectInputStream(bais);
        ChunkData[] chunkDataArray;
        try {
            chunkDataArray = (ChunkData[]) ois.readObject();
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
//        ChunkData[] chunkDataArray = new ArrayList<>();
        overwriteChunks(chunkDataArray);

        String response = "Hello, you have connected to the HttpServer!";
        exchange.sendResponseHeaders(200, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }

    private void overwriteChunks(ChunkData[] chunkDataArray){
            World world = Bukkit.getWorlds().get(0); // Assuming overwriting chunks in the main world
            for (ChunkData chunkData : chunkDataArray) {
                int chunkX = chunkData.getX();
                int chunkZ = chunkData.getZ();

                // Ensure that the chunk is loaded
                Chunk chunk = world.getChunkAt(chunkX, chunkZ);
                if (!chunk.isLoaded()) {
                    chunk.load();
                }

                // Deserialize the chunk data and apply it to the chunk
                chunkData.overwriteChunk(chunk);

                // Save the chunk
                chunk.unload(true);
            }

            System.out.println("Chunk overwriting has completed.");
    }
}
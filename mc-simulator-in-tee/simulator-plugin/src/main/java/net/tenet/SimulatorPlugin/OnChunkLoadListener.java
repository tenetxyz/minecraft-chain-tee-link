package net.tenet.SimulatorPlugin;

import org.bukkit.Chunk;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.world.ChunkLoadEvent;

public class OnChunkLoadListener implements Listener {

    private String getChunkId(Chunk chunk){
        return chunk.getWorld().getName()+ "_" + chunk.getX() + "_" + chunk.getZ();
    }

    @EventHandler
    public void onChunkLoad(ChunkLoadEvent event) {
        Chunk chunk = event.getChunk();
        String chunkId = getChunkId(chunk);
        // call the chain and see if this chunk is loaded
    }
}
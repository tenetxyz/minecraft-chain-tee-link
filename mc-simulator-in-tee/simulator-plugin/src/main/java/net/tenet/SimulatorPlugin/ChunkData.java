package net.tenet.SimulatorPlugin;

import org.bukkit.Chunk;
import org.bukkit.Material;
import org.bukkit.World;
import org.bukkit.block.Block;

import java.io.Serializable;

public class ChunkData implements Serializable {

    private static final long serialVersionUID = 1L;

    private final int x;
    private final int z;
    private final Material[][][] blockData;

    public ChunkData(int x, int z, Material[][][] blockData) {
        this.x = x;
        this.z = z;
        this.blockData = blockData;
    }

    public int getX() {
        return x;
    }

    public int getZ() {
        return z;
    }

    public Material[][][] getBlockData() {
        return blockData;
    }

    public static ChunkData fromChunk(Chunk chunk) {
        int chunkX = chunk.getX();
        int chunkZ = chunk.getZ();
        World world = chunk.getWorld();

        Material[][][] blockData = new Material[16][world.getMaxHeight()][16];

        for (int x = 0; x < 16; x++) {
            for (int y = 0; y < world.getMaxHeight(); y++) {
                for (int z = 0; z < 16; z++) {
                    Block block = world.getBlockAt(chunkX * 16 + x, y, chunkZ * 16 + z);
                    blockData[x][y][z] = block.getType();
                }
            }
        }

        return new ChunkData(chunkX, chunkZ, blockData);
    }

    public void overwriteChunk(Chunk chunk) {
        World world = chunk.getWorld();

        for (int x = 0; x < 16; x++) {
            for (int y = world.getMinHeight(); y < world.getMaxHeight(); y++) {
                for (int z = 0; z < 16; z++) {
                    Block block = world.getBlockAt(chunk.getX() * 16 + x, y, chunk.getZ() * 16 + z);
                    block.setType(blockData[x][y][z], false);
                }
            }
        }
    }
}
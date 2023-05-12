package net.tenet.buildplugin;

import org.bukkit.Material;

public class Block {
    Location location;
    Material blockMaterial;

    Block(Location location, Material blockMaterial) {
        this.location = location;
        this.blockMaterial = blockMaterial;
    }

}

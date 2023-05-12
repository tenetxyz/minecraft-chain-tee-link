package net.tenet.buildplugin;

import org.bukkit.plugin.PluginManager;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;

public final class BuildPlugin extends JavaPlugin {

    @Override
    public void onEnable() {
        // Plugin startup logic
        System.out.println("Tenet plugin has started!");
        PluginManager pluginManager = getServer().getPluginManager();

        File worldEditDataFolder = pluginManager.getPlugin("WorldEdit").getDataFolder();
        File worldEditTenetSelectionsFolder = new File(worldEditDataFolder, "tenet");

        // register command
        getCommand("export_selection").setExecutor(new ExportSelectionCommand(worldEditTenetSelectionsFolder));
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
        System.out.println("Tenet plugin has stopped!");

    }
}

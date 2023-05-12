package net.tenet.buildplugin;

import net.md_5.bungee.api.ChatColor;
import net.md_5.bungee.api.chat.ClickEvent;
import net.md_5.bungee.api.chat.TextComponent;
import org.bukkit.plugin.java.JavaPlugin;

public final class BuildPlugin extends JavaPlugin {

    @Override
    public void onEnable() {
        // Plugin startup logic

        // register command
        getCommand("suggest").setExecutor(new SuggestCommand());
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
    }
}

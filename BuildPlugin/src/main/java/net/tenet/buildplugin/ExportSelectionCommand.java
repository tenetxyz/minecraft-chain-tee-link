package net.tenet.buildplugin;

import net.md_5.bungee.api.ChatColor;
import net.md_5.bungee.api.chat.ClickEvent;
import net.md_5.bungee.api.chat.TextComponent;
import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class ExportSelectionCommand implements CommandExecutor {
    private final File worldEditTenetSelectionsFolder;

    public ExportSelectionCommand(File worldEditTenetSelectionsFolder) {
        this.worldEditTenetSelectionsFolder = worldEditTenetSelectionsFolder;
    }

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {

        if(sender instanceof Player){
            Player player = (Player) sender;

            // execute WorldEdit command to save selection to a file
            boolean saved_election = player.performCommand("/distr");
            if(!saved_election) {
                player.sendMessage("Failed to run WorldEdit //distr command!");
                return true;
            }

            String worldeditSelectionFileName = player.getName() + "-selection.json";
            File worldeditSelectionFile = new File(worldEditTenetSelectionsFolder, worldeditSelectionFileName);
            if(worldeditSelectionFile.exists()) {
                try {
                    String data = new String(Files.readAllBytes(worldeditSelectionFile.toPath()));

                    TextComponent message = new TextComponent("Click here to copy the exported JSON of your selection!");
                    message.setColor(ChatColor.BLUE);
                    message.setClickEvent(new ClickEvent(ClickEvent.Action.COPY_TO_CLIPBOARD, data));

                    player.spigot().sendMessage(message);
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            } else {
                player.sendMessage("No selection found! First select something using WorldEdit.");
            }
        }

        return true;
    }
}

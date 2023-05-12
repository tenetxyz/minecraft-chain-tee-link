package net.tenet.buildplugin;

import com.google.gson.*;
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
                    JsonElement jsonElement = JsonParser.parseString(data);
                    JsonArray selectionCoords = jsonElement.getAsJsonArray();

                    Block[] blocks = new Block[selectionCoords.size()];
                    for(int i = 0; i < selectionCoords.size(); i++){
                        JsonElement jsonElement1 = selectionCoords.get(i);
                        JsonObject coordData = jsonElement1.getAsJsonObject();
                        int x = coordData.get("x").getAsInt();
                        int y = coordData.get("y").getAsInt();
                        int z = coordData.get("z").getAsInt();
                        // get block at this location
                        org.bukkit.block.Block block = player.getWorld().getBlockAt(x, y, z);
                        blocks[i] = new Block(new Location(x, y, z), block.getType());
                    }
                    Creation creation = new Creation(blocks);
                    Gson gson = new Gson();
                    String creationJson = gson.toJson(creation);

                    TextComponent message = new TextComponent("Click here to copy the exported JSON of your selection!");
                    message.setColor(ChatColor.BLUE);
                    message.setClickEvent(new ClickEvent(ClickEvent.Action.COPY_TO_CLIPBOARD, creationJson));

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

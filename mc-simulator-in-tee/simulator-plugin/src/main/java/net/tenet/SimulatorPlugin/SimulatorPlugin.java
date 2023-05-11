package net.tenet.SimulatorPlugin;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

import org.bukkit.Material;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.block.Action;
import org.bukkit.event.player.PlayerInteractEvent;
import org.bukkit.plugin.PluginManager;
import org.bukkit.plugin.java.JavaPlugin;

public final class SimulatorPlugin extends JavaPlugin {
    private final int port = 8080;

    @Override
    public void onEnable() {
        // Plugin startup logic
        System.out.println("Tenet plugin has started!");
        try{
            createServer();
        }catch(IOException e){
            System.out.println(e);
        }
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
        System.out.println("Tenet plugin has stopped!");
    }

    // This server will listen to incoming requests to test creations.
    // When the server receives the request, it will spawn the creation inside
    // the world and execute it
    public void createServer() throws IOException{
        HttpServer apiServer = HttpServer.create(new InetSocketAddress(port), 0);
        apiServer.createContext("/set-chunks", new SetChunksHandler());
        apiServer.start();
    }
}

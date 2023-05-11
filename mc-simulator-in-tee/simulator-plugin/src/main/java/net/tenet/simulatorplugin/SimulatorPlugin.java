package net.tenet.simulatorplugin;

import com.sun.net.httpserver.HttpServer;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class SimulatorPlugin extends JavaPlugin {
    private HttpServer apiServer;
    private static final int API_SERVER_PORT = 4500;
    private Map<String, Creation> creations = new ConcurrentHashMap<>(); // maps creationId -> Creation

    @Override
    public void onEnable() {
        // Plugin startup logic
        System.out.println("Tenet plugin has started!");
        try {
            createServer();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    @Override
    public void onDisable() {
        // Plugin shutdown logic
        apiServer.stop(0);
        System.out.println("Tenet plugin has stopped!");
    }

    // This server will listen to incoming requests to test creations.
    // When the server receives the request, it will spawn the creation inside
    // the world and execute it
    public void createServer() throws IOException {
        apiServer = HttpServer.create(new InetSocketAddress(API_SERVER_PORT), 0);
        apiServer.createContext("/activate-creation", new ActivateCreationHandler(this, creations));
        apiServer.createContext("/get-creation-output", new GetCreationOutputHandler(creations));
        apiServer.start();
    }
}

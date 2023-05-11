package net.tenet.SimulatorPlugin;

public class ActivateCreationRequest {
    String worldName; // This is not used at the moment since we only support the overworld
    String ownerPlayerId;
    Block[] blocks;
}


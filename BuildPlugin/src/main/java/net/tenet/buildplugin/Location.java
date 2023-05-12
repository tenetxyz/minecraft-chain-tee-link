package net.tenet.buildplugin;

public class Location {
    int x;
    int y;
    int z;

    Location(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public String toString() {
        return x + "," + y + "," + z;
    }
}
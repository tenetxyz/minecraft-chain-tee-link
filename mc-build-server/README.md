## Creating a MC Build Server

1. Add the following plugins:
- WorldEdit - Tenet fork (https://github.com/tenetxyz/WorldEdit/tree/tenet-main)
- BuildPlugin by Tenet (https://github.com/tenetxyz/mc-on-chain/tree/main/mc-build-server/BuildPlugin)
- PlotSquared (https://github.com/IntellectualSites/PlotSquared)

2. Delete default Minecraft worlds `world/`, `world_nether/`, `world_the_end/`

3. Edit `server.properties` to add plot world and disable nether world
    - `level-name=plotworld`
    -  `allow-nether=false`

3. Edit `bukkit.yml` to disable end world and specify how to generate plot world
    - `allow-end: false`
    - ```
      worlds:
        plotworld:
          generator: PlotSquared
        ```
4. Edit `plugins/PlotSquared/config/worlds.yml` to allow entities to be spawned using eggs and via breeding
    - ```
      event:
        spawn:
          egg: true
          breeding: true
          custom: true
      ```

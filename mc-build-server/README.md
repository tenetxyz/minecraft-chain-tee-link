## Creating a MC Build Server

1. Add the following plugins:
- WorldEdit - Tenet fork (https://github.com/tenetxyz/WorldEdit/tree/tenet-main)
- BuildPlugin by Tenet (https://github.com/tenetxyz/mc-on-chain/tree/main/mc-build-server/BuildPlugin)
- PlotSquared (https://github.com/IntellectualSites/PlotSquared)

2. Edit server.properties
    - `level-name=plotworld`
    -  `allow-nether=false`

3. Edit bukkit.yml
    - `allow-end: false`
    - ```
      worlds:
        plotworld:
          generator: PlotSquared
        ```
4. To customize plots, edit: `plugins/PlotSquared/config/worlds.yml`

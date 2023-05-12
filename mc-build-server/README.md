## Creating a MC Build Server

1. Add the following plugins:
- WorldEdit - Tenet fork
- BuildPlugin by Tenet
- PlotSquared

2. Edit server.properties
    - `level-name=plotworld`
    -  `allow-nether=false`

3. Edit bukkit.yml
    - `allow-end: false`
    - ```
        worlds:
          plotworld:
            generator: PLotSquared
        ```

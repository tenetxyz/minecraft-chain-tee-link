.PHONY: buildPlugin

run:
# We need to cd into the SpigotServer directory because when the server starts it checks the current directory for eula.txt
	cd SpigotServer; java -Xmx1024M -Xms1024M -jar spigot-1.19.3.jar nogui

plugin:
	mvn -f simulator-plugin/pom.xml package && \
	cp simulator-plugin/target/simulator-plugin-1.0-SNAPSHOT.jar SpigotServer/plugins

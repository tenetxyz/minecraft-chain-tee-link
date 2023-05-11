#!/bin/bash

workingDir=$(pwd)

# download the buildtools and generate the spigot server from it.
mkdir BuildTools
cd BuildTools
wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
export MAVEN_OPTS="-Xmx2G"
java -Xmx2G -jar BuildTools.jar --rev 1.19.3 --remapped

cd $workingDir
mkdir SpigotServer
# set the default world of the server to the void world (creations will spawn here)
cp -r voidworld SpigotServer
mv SpigotServer/voidworld SpigotServer/world

# copy the generated spigot server and start the server.
cp BuildTools/spigot-1.19.3.jar SpigotServer
cd SpigotServer
echo eula=true > eula.txt
java -Xmx1024M -Xms1024M -jar spigot-1.19.3.jar nogui


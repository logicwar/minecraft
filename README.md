[hub]:https://hub.docker.com/r/logicwar/minecraft/
[itzg]:https://hub.docker.com/r/itzg/minecraft-server/
[Minecraft_wikipedia]:https://en.wikipedia.org/wiki/Minecraft
[tz_wikipedia]:https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
[eula]:https://account.mojang.com/documents/minecraft_eula
[pocketmine]:https://github.com/pmmp/PocketMine-MP/releases

# [Docker Container for JAVA & PE Minecraft][hub]

This is a Docker image based on osixia/light-baseimage for running  a VANILLA, FORGE, FTB, SPIGOT or POCKETMINE Minecraft server on Java AdoptOpenJDK jdk-16.0.1+9 or PHP 7.2 (it is inspired by the awesome work of : [itzg/minecraft-server][itzg]).

Minecraft is a sandbox video game created and designed by Swedish game designer Markus "Notch" Persson, and later fully developed and published by Mojang. The creative and building aspects of Minecraft allow players to build with a variety of different cubes in a 3D procedurally generated world. Other activities in the game include exploration, resource gathering, crafting, and combat. [Wikipedia][Minecraft_wikipedia]

Minecraft is a commercial licence released under the terms of the [Minecraft EULA][eula].

## Usage (minimal)
It will automatically download the latest 'VANILLA' stable version of Minecraft and run it with the below **default properties**.

```
docker run -it --name=minecraft \ 
              -v <path for data files>:/opt/minecraft/data:rw \
              -e DGID=<gid>
              -e DUID=<uid> \
              -e TZ=<timezone> \
              -e EULA=TRUE\
              -p 25565:25565 \
              -p 25575:25575 \
              logicwar/minecraft
```
### Start/Stop
You can then start/stop the server with :

* `docker start minecraft` or `docker start -i minecraft` if you want direct interaction
* `docker stop minecraft` 

### Shell access
For shell access while the container is running do :

`docker exec -it minecraft /bin/bash`

### Server interaction
For Minecraft server interaction you can attach by using :

`docker attach minecraft` and then `Control-p` followed by `Control-q` to detach

From an attached console type `stop` or press `Control-c` to stop the server.

### Data access
If you need for exemple to modify the** server.properties**, copy a new **world** or copy **mods** you need to access the mounted volume.

**Note:** modify the** server.properties** file when the server is stopped

If you are not using a 'persistent' volume but the auto-created volume, then you can determine it by using :

`docker inspect -f '{{ .Mounts }}' minecraft`

It will return something like this :
```
[{volume 6f58390b223b8427a8515ea4aad9279e4ed618d2e2eb1d425e0d6f98d88fec6c /var/lib/docker/volumes/6f58390b223b8427a8515ea4aad9279e4ed618d2e2eb1d425e0d6f98d88fec6c/_data /opt/minecraft/data local  true }]
```
You will then need **root** rights to access the `/var/lib/docker/volumes/6f5839...8fec6c/_data` folder.

## Parameters
* `-p 25565` - server port
* `-p 25575` - rcon port (if enabled)
* `-v /opt/minecraft/data` - local path for the installation
* `-e DGID` for GroupID - see below for explanation
* `-e DUID` for UserID - see below for explanation
* `-e TZ` for timezone information : Europe/London, Europe/Zurich, America/New_York, ... ([List of TZ][tz_wikipedia])
* `-e EULA` - set to TRUE to accept the [Minecraft EULA][eula]

## Other Parameters

### Installation
* `-e TYPE` - type of server to deploy (VANILLA|FORGE|FTB|SPIGOT **default:** VANILLA)
* `-e VERSION` - version of Minecraft to deploy (specific version such as "1.12.2"|LATEST|SNAPSHOT **default:** LATEST)
* `-e FORGEVERSION` - version of Forge to deploy (specific version such as ""|RECOMMENDED|LATEST **default:** RECOMMENDED) !Works in conjunction  with `VERSION`!
* `-e FORGE_INSTALLER` - file name of a pre-downloaded Forge installer placed in the attached 'data' directory
* `-e FORGE_INSTALLER_URL`- url of a Forge installer to download
* `-e FTB_SERVER_MODPACK` - file name of a pre-downloaded FTB modpack zip file placed in the attached 'data' directory
* `-e FTB_SERVER_MODPACK_URL` - url of a FTB modpack zip file to download
* `-e SPIGOT_DOWNLOAD_URL` - url of an already compiled SPIGOT jar file to download
* `-e SPIGOT_SERVER` - file name of a pre-downloaded and pre-compiled SPIGOT server file placed in the attached 'data' directory

### Java Command Line
* `-e JVM_OPTS` - Java options
* `-e JVM_XX_OPTS` - experimental Java options (**default:** -XX:+UseG1GC)
* `-e JVM_MIN_MEM` - initial allocated Java memory (**default:** 1GB)
* `-e JVM_MAX_MEM` - maximum allocated Java memory (**default:** 2GB)~~~~

### Minecraft Server Properties

* `-e ALLOW_NETHER` - (TRUE|FALSE **default:0M8x5ASuniWEh9LCVvNZ** TRUE)
* `-e ANNOUNCE_PLAYER_ACHIEVEMENTS` - (TRUE|FALSE **default:** TRUE)
* `-e DIFFICULTY` - (PEACEFUL|0|EASY|1|NORMAL|2|HARD|3 **default:** 1)
* `-e ENABLE_COMMAND_BLOCK` - (TRUE|FALSE **default:** TRUE)
* `-e ENABLE_QUERY` - (TRUE|FALSE **default:** FALSE)
* `-e ENABLE_RCON` - (TRUE|FALSE **default:** FALSE)
* `-e FORCE_GAMEMODE` - (TRUE|FALSE **default:** FALSE)
* `-e GAMEMODE` - (SURVIVAL|0|CREATIVE|1|ADVENTURE|2|SPECTATOR|3 **default:** 0) 
* `-e GENERATE_STRUCTURES` - (TRUE|FALSE **default:** TRUE)
* `-e GENERATOR_SETTINGS` - (**default:** blankn)
* `-e HARDCORE` - (TRUE|FALSE **default:** FALSE)
* `-e LEVEL_NAME` - world name and its folder name (**default:** world)
* `-e LEVEL_TYPE` - (DEFAULT|FLAT|LARGEBIOMES|AMPLIFIED|CUSTOMIZED|BIOMESOP|RTG **default:** DEFAULT)
* `-e MAX_BUILD_HEIGHT` - (**default:** 256)
* `-e MAX_PLAYERS` - (**default:** 20)
* `-e MAX_TICK_TIME` - (**default:** 60000)
* `-e MAX_WORLD_SIZE` - (**default:** 29999984)
* `-e MOTD` - (**default:** "A Minecraft Server (Docker)")
* `-e ONLINE_MODE` - (TRUE|FALSE **default:** TRUE)
* `-e PVP` - (TRUE|FALSE **default:** TRUE)
* `-e QUERY_PORT` - (**default:** 25565)
* `-e RCON_PASSWORD` - (**default:** blank)
* `-e RCON_PORT` - (**default:** 25575)
* `-e LEVEL_SEED` - (**default:** blank)
* `-e SERVER_PORT` - (**default:** 25565)
* `-e SPAWN_ANIMALS` - (TRUE|FALSE **default:** TRUE)
* `-e SPAWN_MONSTERS` - (TRUE|FALSE **default:** TRUE)
* `-e SPAWN_NPCS` - (TRUE|FALSE **default:** TRUE)
* `-e VIEW_DISTANCE` - (**default:** 10)

### User / Group ID

For security reasons and to avoid permissions issues with data volumes (`-v` flags), you may want to create a specific "docker" user with proper right accesses on your persistant folders. To find your user **uid** and **gid** you can use the `id <user>` command as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

and finally specify your "docker" user `DUID` and group `DGID`. In this exemple `DUID=1001` and `DGID=1001`.

## How to deploy a VANILLA server

To simply use the **LATEST** stable Minecraft version, run :

```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=VANILLA \
               -p 25565:25565 \
               logicwar/minecraft
```
To run a specific version :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=VANILLA \
               -e VERSION="1.10.2" \
               -p 25565:25565 \
               logicwar/minecraft
```

To use a persistant 'data' directory on you host filesystem (make sure to use a User and Group ID which have proper accesses to the host directory) :
```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=VANILLA \
               -p 25565:25565 \
               logicwar/minecraft
```

Don’t forget that you can add other parameters to change default server behaviour (see **Other Parameters**).

## How to deploy a FORGE server

To simply use the **RECOMMENDED** Forge with the **LATEST** Minecraft versions, run :

```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=FORGE \
               -p 25565:25565 \
               logicwar/minecraft
```
To run specific versions (i.e. Minecraft 1.10.2 and Forge 12.18.3.2477) :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=FORGE \
               -e VERSION="1.10.2" \
               -e FORGEVERSION="12.18.3.2477"
               -p 25565:25565 \
               logicwar/minecraft
```
To download a Forge installer from a specific URL :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=FORGE \
               -e FORGE_INSTALLER_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.10.2-12.18.3.2488/forge-1.10.2-12.18.3.2488-installer.jar" \
               -p 25565:25565 \
               logicwar/minecraft
```

To use a persistant 'data' directory on you host filesystem (make sure to use a User and Group ID which have proper accesses to the host directory) :
```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=FORGE \
               -p 25565:25565 \
               logicwar/minecraft
```

To use a pre-downloaded Forge **installer**, place it in the attached /data directory and specify the name of the installer file with FORGE_INSTALLER :

```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=FORGE \
               -e FORGE_INSTALLER="forge-1.10.2-12.18.3.2488-installer.jar"
               -p 25565:25565 \
               logicwar/minecraft
```
Don’t forget that you can add other parameters to change default server behaviour (see **Other Parameters**).

###Installing the mods
* The **mods** must copied in the 'mods' folder of the /opt/minecraft/data/ mount.
* The **mod configuration** files must be copied in the 'config' folder of the /opt/minecraft/data/ mount.

To be taken into account the container must be restarted.
 
## How to deploy an FTB server

To download an FTB installer from a specific URL :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=FTB \
               -e FTB_SERVER_MODPACK_URL="https://www.feed-the-beast.com/projects/ftb-presents-skyfactory-3/files/2481284/download" \
               -p 25565:25565 \
               logicwar/minecraft
```

To use a persistant 'data' directory on you host filesystem (make sure to use a User and Group ID which have proper accesses to the host directory) :
```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=FTB \
               -e FTB_SERVER_MODPACK_URL="https://www.feed-the-beast.com/projects/ftb-presents-skyfactory-3/files/2481284/download" \
               -p 25565:25565 \
               logicwar/minecraft
```

To use a pre-downloaded FTB **modpack**, place it in the attached /data directory and specify the name of the installer file with FTB_SERVER_MODPACK :

```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=FTB \
               -e FTB_SERVER_MODPACK="FTBPresentsSkyfactory3Server_3.0.15.zip" \
               -p 25565:25565 \
               logicwar/minecraft
```
If you don't want to use the default memory settings defined by the FTB modpack, you can use  `JVM_MIN_MEM` and `JVM_MAX_MEM`. You can also set different `JVM_XX_OPTS` parameters.

## How to deploy a SPIGOT server

To download and compile a SPIGOT server for a specific Minecraft version :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=SPIGOT \
               -e VERSION="1.12.2" \
               -p 25565:25565 \
               logicwar/minecraft
```

To download a pre-compiled SPIGOT version from a specific URL :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=SPIGOT \
               -e SPIGOT_DOWNLOAD_URL="https://www.myurl.com/download/spigot-1.12.2.jar" \
               -p 25565:25565 \
               logicwar/minecraft
```


To use a persistant 'data' directory on you host filesystem (make sure to use a User and Group ID which have proper accesses to the host directory) :
```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=SPIGOT \
               -e VERSION="1.12.2" \
               -p 25565:25565 \
               logicwar/minecraft
```
To use a pre-downloaded and pre-compiled SPIGOT version, place it in the attached /data directory and specify the name of the server file with SPIGOT_SERVER :

```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=SPIGOT \
               -e SPIGOT_SERVER="spigot-1.12.2.jar" \
               -p 25565:25565 \
               logicwar/minecraft
```
###Installing plugins
* The **plugins** must copied in the 'plugins' folder of the /opt/minecraft/data/ mount.

To be taken into account the container must be restarted.

## How to deploy a POCKETMINE server

To download and install the latest version of POCKETMINE server :
```
  $ docker run -it --name=minecraft \
               -e EULA=TRUE \
               -e TYPE=POCKETMINE \
               -p 19132:25565/udp \
               logicwar/minecraft
```

To use a persistant 'data' directory on you host filesystem (make sure to use a User and Group ID which have proper accesses to the host directory) :
```
  $ docker run -it --name=minecraft \
               -v <path for data files>:/opt/minecraft/data:rw \
               -e DGID=<gid> \
               -e DUID=<uid> \
               -e EULA=TRUE \
               -e TYPE=POCKETMINE \
               -p 19132:25565/udp \
               logicwar/minecraft
```
###Installing plugins
* The **plugins** must copied in the 'plugins' folder of the /opt/minecraft/data/ mount.

To be taken into account the container must be restarted.

###Updating PocketMine-MP
* Stop the container.
* Delete your current PocketMine-MP.phar in your  "data" folder and replace it with the version you need (latest?) from : [Download][pocketmine].
* Restart the container.

## All Server default configuation

The server intitial setup is made using the following default values and can be overriden by editing the `server.properities` file when the service is stopped or for some properties at server creation : 

|Properties|Default value|
|---|---|
|allow-flight|false|
|allow-nether|true|
|announce-player-achievements|true|
|difficulty|1|
|enable-command-block|true|
|enable-query|false|
|enable-rcon|false|
|force-gamemode|false|
|gamemode|0|
|generate-structures|true|
|generator-settings||
|hardcore|false|
|level-name|world|
|level-seed||
|level-type|DEFAULT|
|max-build-height|256|
|max-players|20|
|max-tick-time|60000|
|max-world-size|29999984|
|motd|A Minecraft Server (Docker)|
|network-compression-threshold|256|
|online-mode|true|
|op-permission-level|4|
|player-idle-timeout|0|
|prevent-proxy-connections|false|
|pvp|true|
|query.port|25565|
|rcon.password||
|rcon.port|25575|
|resource-pack||
|resource-pack-sha1||
|server-ip||
|server-port|25565|
|snooper-enabled|true|
|spawn-animals|true|
|spawn-monsters|true|
|spawn-npcs|true|
|spawn-protection|-1|
|texture-pack||
|use-native-transport|true|
|view-distance|10|
|white-list|false|

## Sample of a simple docker-compose.yml
```
version: "3"

services:
  minecraft-server:
    image: logicwar/minecraft:latest
    volumes:
      - "/ContainerPersistentMounts/Minecraft/PocketMine/Data1:/opt/minecraft/data:rw"
    ports:
      - "19132:25565/udp"
      - "19132:25575"
    environment:
      EULA: "TRUE"
      DUID: "1004"
      DGID: "1003"
      ENABLE_RCON: "FALSE"
      MOTD: "Home Server - PocketMine - 1"
      TYPE: "POCKETMINE"
      TZ: "Europe/Zurich"
      GAMEMODE: "0"
      DIFFICULTY: "1"
    container_name: "minecraft-server-pm-1"
    hostname: "minecraft-server-pm-1"
    network_mode: "bridge"
    tty: true
    stdin_open: true
```

## Versions
+ **V0.1** Initial Release
+ **V0.2** Quick fix to load  13.1 VANILLA version and add POCKETMINE Support
+ **V0.3** Update to jre-8u201
+ **V0.4** Update to jre-8u211, temporary solution for required login to download java, use of version_manifest.json to retreive download jar url
+ **V0.5** Update to osixia/light-baseimage 1.3.3, change for AdoptOpenJDK jdk-16.0.1+9 (removal of the temp solution for java), default maximum allocated Java memory changed to 2 GB
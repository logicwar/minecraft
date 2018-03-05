#!/bin/bash

###############
## CONSTANTS ##
###############
SERVER_PROPERTIES=$INSTALL_DIR/server.properties

###############
## FUNCTIONS ##
###############

######################################################################### 
# Function : setParameter
# Purpose  : Set the server parameters
# Remarks  : -
######################################################################### 
function setParameter {
	local parameter=$1
	local value=$2
	if [ -n "$value" ]; then
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Setting ${parameter} to '${value}'"
		sed -i "/^${parameter}\s*=/ c ${parameter}=${value}" $SERVER_PROPERTIES
	fi
}


#########################################
##       DEPLOY SERVER.PROPERTIES      ##
#########################################
# Deploy server.properties file
if [ ! -f $SERVER_PROPERTIES ]; then

	echo "[$(date +"%H:%M:%S")] [Container Setup]: Copying and modifiying server.properties in ${SERVER_PROPERTIES}"
	case "$TYPE" in
	  *)
		cp /defaults/server.properties_VANILLA $SERVER_PROPERTIES
		;;
	esac

	# "standard" parameters
	setParameter "motd" "$MOTD"
	setParameter "server-port" "$SERVER_PORT"
	setParameter "online-mode" "$ONLINE_MODE"
	setParameter "level-name" "$LEVEL_NAME"
	setParameter "pvp" "$PVP"
	setParameter "allow-nether" "$ALLOW_NETHER"
	setParameter "announce-player-achievements" "$ANNOUNCE_PLAYER_ACHIEVEMENTS"
	setParameter "enable-command-block" "$ENABLE_COMMAND_BLOCK"
	setParameter "spawn-animals" "$SPAWN_ANIMALS"
	setParameter "spawn-monsters" "$SPAWN_MONSTERS"
	setParameter "spawn-npcs" "$SPAWN_NPCS"
	setParameter "generate-structures" "$GENERATE_STRUCTURES"
	setParameter "view-distance" "$VIEW_DISTANCE"
	setParameter "hardcore" "$HARDCORE"
	setParameter "max-build-height" "$MAX_BUILD_HEIGHT"
	setParameter "force-gamemode" "$FORCE_GAMEMODE"
	setParameter "hardmax-tick-timecore" "$MAX_TICK_TIME"
	setParameter "enable-query" "$ENABLE_QUERY"
	setParameter "query.port" "$QUERY_PORT"
	setParameter "enable-rcon" "$ENABLE_RCON"
	setParameter "rcon.password" "$RCON_PASSWORD"
	setParameter "rcon.port" "$RCON_PORT"
	setParameter "max-players" "$MAX_PLAYERS"
	setParameter "max-world-size" "$MAX_WORLD_SIZE"
	setParameter "level-seed" "$LEVEL_SEED"
	setParameter "generator-settings" "$GENERATOR_SETTINGS"

	# "level-type" parameters
	if [ -n "$LEVEL_TYPE" ]; then
		# Normalize to uppercase
		LEVEL_TYPE=$( echo ${LEVEL_TYPE} | tr '[:lower:]' '[:upper:]' )
		# check for valid values and only then set
		case $LEVEL_TYPE in 
		  DEFAULT|FLAT|LARGEBIOMES|AMPLIFIED|CUSTOMIZED|BIOMESOP|RTG)
			setParameter "level-type" "$LEVEL_TYPE"
			;;
		  *)
			echo "Invalid LEVEL_TYPE: $LEVEL_TYPE"
			echo "Valid types: DEFAULT|FLAT|LARGEBIOMES|AMPLIFIED|CUSTOMIZED|BIOMESOP|RTG"
			exit
			;;
		esac
	fi

	# "difficulty" parameters
	if [ -n "$DIFFICULTY" ]; then
		# Normalize to uppercase
		DIFFICULTY=$( echo ${DIFFICULTY} | tr '[:lower:]' '[:upper:]' )
		case $DIFFICULTY in
		  PEACEFUL|0)
			DIFFICULTY=0
			;;
		  EASY|1)
			DIFFICULTY=1
			;;
		  NORMAL|2)
			DIFFICULTY=2
			;;
		  HARD|3)
			DIFFICULTY=3
			;;
		  *)
			echo "Invalid DIFFICULTY: $DIFFICULTY"
			echo "Valid types: PEACEFUL|0|EASY|1|NORMAL|2|HARD|3"
			exit
			;;
		esac
		setParameter "difficulty" "$DIFFICULTY"
	fi

	# "gamemode" parameters
	if [ -n "$GAMEMODE" ]; then
		# Normalize to uppercase
		GAMEMODE=$( echo $GAMEMODE | tr '[:lower:]' '[:upper:]' )
		case $GAMEMODE in
		  SURVIVAL|0)
			GAMEMODE=0
			;;
		  CREATIVE|1)
			GAMEMODE=1
			;;
		  ADVENTURE|2)
			GAMEMODE=2
			;;
		  SPECTATOR|3)
			GAMEMODE=3
			;;
		  *)
			echo "Invalid GAMEMODE: $GAMEMODE"
			echo "Valid types: SURVIVAL|0|CREATIVE|1|ADVENTURE|2|SPECTATOR|3"
			exit
			;;
	    esac
	    setParameter "gamemode" "$GAMEMODE"
	fi

else
	echo "'server.properties' already exists in directory, skipping"
fi


#########################################
##         JAVA MEMORY SETTINGS        ##
#########################################
echo "[$(date +"%H:%M:%S")] [Container Setup]: Setting min JAVA allocated memory to $JVM_MIN_MEM and max to $JVM_MAX_MEM"
JVM_OPTS="-Xms$JVM_MIN_MEM -Xmx$JVM_MAX_MEM $JVM_OPTS"


#########################################
##       EXPORT TO CONTAINER ENV       ##
#########################################
#Used by 'process.sh'
echo $INSTALL_DIR >> /container/environment/INSTALL_DIR
echo $SERVER >> /container/environment/SERVER
echo $JVM_OPTS >> /container/environment/JVM_OPTS
echo $JVM_XX_OPTS  >> /container/environment/JVM_XX_OPTS

# FTB Export
if [ ! -z $FTB_SERVER_START ]; then
	echo $FTB_SERVER_START >> /container/environment/FTB_SERVER_START
	# Override default JVM Arguments
	if [ ! -z $JVM_MIN_MEM ]; then echo "export MIN_RAM=\"$JVM_MIN_MEM\"" >> $INSTALL_DIR/settings-local.sh;fi
	if [ ! -z $JVM_MAX_MEM ]; then echo "export MAX_RAM=\"$JVM_MAX_MEM\"" >> $INSTALL_DIR/settings-local.sh;fi
	if [ ! -z "$JVM_XX_OPTS" ]; then echo "export JAVA_PARAMETERS=\"$JVM_XX_OPTS\"" >> $INSTALL_DIR/settings-local.sh;fi
fi


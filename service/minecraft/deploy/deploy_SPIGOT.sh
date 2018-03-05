#!/bin/bash

###############
## CONSTANTS ##
###############
SPIGOT_DOWNLOAD="https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar"

#########################################
##       DOWNLOAD OR BUILD SPIGOT      ##
#########################################
if [ -z $SPIGOT_SERVER ]; then
	if [ ! -z $SPIGOT_DOWNLOAD_URL ]; then
		export SERVER="spigot.jar"
		# Download compiled version of Spigot
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading from <$SPIGOT_DOWNLOAD_URL>"
		cd $INSTALL_DIR
		wget -q -O $SERVER $SPIGOT_DOWNLOAD_URL
	else
		export SERVER="spigot-$VANILLA_VERSION.jar"
		# Download latest Spigot sources
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading latest SPIGOT sources"
		mkdir $INSTALL_DIR/tmp
		cd $INSTALL_DIR/tmp
		wget -q $SPIGOT_DOWNLOAD

		# Build from sources
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Building from sources for Minecraft $VANILLA_VERSION (can take some time...)"
		# Build
		java -jar $INSTALL_DIR/tmp/BuildTools.jar --rev $VANILLA_VERSION
		# Setup & Clean up
		mv spigot-$VANILLA_VERSION.jar $INSTALL_DIR
		cd $INSTALL_DIR
		mkdir -p plugins
		echo "Cleaning up"
		rm -rf $INSTALL_DIR/tmp
	fi
else
	export SERVER=$SPIGOT_SERVER
fi

#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


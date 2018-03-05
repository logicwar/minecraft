#!/bin/bash

###############
## CONSTANTS ##
###############
export SERVER="minecraft_server.$VANILLA_VERSION.jar"
MINECRAFT_DOWNLOAD="https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER"

#########################################
##          DOWNLOAD MINECRAFT         ##
#########################################
# Download the selected version of minecraft
if [ ! -e $SERVER ]; then
	echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading $SERVER ..."
	cd $INSTALL_DIR
	wget -q $MINECRAFT_DOWNLOAD
fi

#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


#!/bin/bash

###############
## CONSTANTS ##
###############
export SERVER="minecraft_server.$VANILLA_VERSION.jar"
case "$VANILLA_VERSION" in
  1.13)
	MINECRAFT_DOWNLOAD="https://launcher.mojang.com/mc/game/1.13/server/d0caafb8438ebd206f99930cfaecfa6c9a13dca0/server.jar"
	;;
  *)
	MINECRAFT_DOWNLOAD="https://s3.amazonaws.com/Minecraft.Download/versions/$VANILLA_VERSION/$SERVER"

	;;
esac

#########################################
##          DOWNLOAD MINECRAFT         ##
#########################################
# Download the selected version of minecraft
if [ ! -e $SERVER ]; then
	echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading $SERVER ..."
	cd $INSTALL_DIR
	wget -q -O $SERVER $MINECRAFT_DOWNLOAD
fi

#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


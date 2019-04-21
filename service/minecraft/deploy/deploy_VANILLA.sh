#!/bin/bash

###############
## CONSTANTS ##
###############
export SERVER="minecraft_server.$VANILLA_VERSION.jar"

#########################################
##           GET DOWNLOAD URL          ##
#########################################
VERSIONMANIFESTURL=`curl -fsSL $VERSIONS_JSON | jq --arg VANILLA_VERSION "$VANILLA_VERSION" --raw-output '[.versions[]|select(.id == $VANILLA_VERSION)][0].url'`
MINECRAFT_DOWNLOAD=`curl -fsSL $VERSIONMANIFESTURL | jq --raw-output '.downloads.server.url'`

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


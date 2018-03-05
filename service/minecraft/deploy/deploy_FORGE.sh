#!/bin/bash

###############
## CONSTANTS ##
###############
CHECK_FORGEVERSION_URL="http://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json"
FORGE_DOWNLOAD="http://files.minecraftforge.net/maven/net/minecraftforge/forge"

mkdir $INSTALL_DIR/tmp
#########################################
##     DETERMINE THE FORGE VERSION     ##
#########################################
if [[ -z $FORGE_INSTALLER && -z $FORGE_INSTALLER_URL ]]; then
	echo "[$(date +"%H:%M:%S")] [Container Setup]: Determine the Forge version to use"
	curl -fsSL -o $INSTALL_DIR/tmp/forge.json $CHECK_FORGEVERSION_URL
	case $FORGEVERSION in
	  RECOMMENDED|recommended)
		DETERMINED_FORGEVERSION=$(cat $INSTALL_DIR/tmp/forge.json | jq -r ".promos[\"$VANILLA_VERSION-recommended\"]")
		;;
	  LATEST|latest)
		DETERMINED_FORGEVERSION=$(cat $INSTALL_DIR/tmp/forge.json | jq -r ".promos[\"$VANILLA_VERSION-latest\"]")
		;;
	  *)
		DETERMINED_FORGEVERSION=$FORGEVERSION
		;;
	esac
	if [ $DETERMINED_FORGEVERSION = null ]; then
		echo ""
		echo "ERROR: Minecraft Version $VANILLA_VERSION is not supported by Forge"
		echo "       Refer to http://files.minecraftforge.net/ for supported versions"
		exit
	fi
fi


#########################################
##            DOWNLOAD FORGE           ##
#########################################
if [ -z $FORGE_INSTALLER ]; then
	if [ -z $FORGE_INSTALLER_URL ]; then
		# Download FORGE
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading $FORGEFILENAME"
		FORGEFOLDERNAME="$VANILLA_VERSION-$DETERMINED_FORGEVERSION"
		FORGEFILENAME="forge-$VANILLA_VERSION-$DETERMINED_FORGEVERSION-installer.jar"
		FORGE_INSTALLER=$FORGEFILENAME
		wget -q -O $INSTALL_DIR/tmp/$FORGE_INSTALLER "$FORGE_DOWNLOAD/$FORGEFOLDERNAME/$FORGEFILENAME"
	else
		# Download FORGE from provided URL
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading $FORGE_INSTALLER_URL"
		FORGE_INSTALLER="forge-installer.jar"
		wget -q -O $INSTALL_DIR/tmp/$FORGE_INSTALLER $FORGE_INSTALLER_URL
	fi
fi


#########################################
##            INSTALL FORGE            ##
#########################################
echo "[$(date +"%H:%M:%S")] [Container Setup]: Installing FORGE $DETERMINED_FORGEVERSION"
# Install
cd $INSTALL_DIR
mkdir -p mods \
         config
java -jar $INSTALL_DIR/tmp/$FORGE_INSTALLER --installServer

# Determine the Forge server jar
export SERVER="$(find forge-*-universal.jar)"
if [ -z $SERVER ]; then
	echo ""
	echo "ERROR: Cannot determine the Forge server jar"
	exit			
fi

#Clean
rm -rf $INSTALL_DIR/tmp


#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


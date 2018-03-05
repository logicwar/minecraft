#!/bin/bash

###############
## CONSTANTS ##
###############
export VERSIONS_JSON="https://launchermeta.mojang.com/mc/game/version_manifest.json"
export INSTALL_DIR="/opt/minecraft/data"

#########################################
##           MINECRAFT EULA            ##
#########################################
if [ ! -f $INSTALL_DIR/eula.txt ]; then
	if [ "$EULA" != "" ]; then
		echo "eula=TRUE" >> $INSTALL_DIR/eula.txt
	else
		echo ""
	  	echo "====================================>"
	  	echo "You need to accept the Minecraft EULA"
		echo "by adding : -e EULA=TRUE"
	  	echo "<===================================="
		exit
	fi
fi


#########################################
##          MINECRAFT VERSION          ##
#########################################
case "X$VERSION" in
  X|XLATEST|Xlatest)
	export VANILLA_VERSION=`curl -fsSL $VERSIONS_JSON | jq -r '.latest.release'`
	;;
  XSNAPSHOT|Xsnapshot)
	export VANILLA_VERSION=`curl -fsSL $VERSIONS_JSON | jq -r '.latest.snapshot'`
	;;
  X[1-9]*)
	export VANILLA_VERSION=$VERSION
	;;
  *)
	export VANILLA_VERSION=`curl -fsSL $VERSIONS_JSON | jq -r '.latest.release'`
	;;
esac


#########################################
##        SERVER TYPE DEPLOYMENT       ##
#########################################
echo "[$(date +"%H:%M:%S")] [Container Setup]: Deploying a '$TYPE' Minecraft server"
case "$TYPE" in
  SPIGOT|spigot)
	exec /container/service/minecraft/deploy/deploy_SPIGOT.sh
	;;

  FORGE|forge)
	exec /container/service/minecraft/deploy/deploy_FORGE.sh
	;;

  FTB|ftb)
	exec /container/service/minecraft/deploy/deploy_FTB.sh
	;;

  VANILLA|vanilla)
	exec /container/service/minecraft/deploy/deploy_VANILLA.sh
	;;

  *)
	echo "Invalid type: '$TYPE'"
	echo "Valid types: VANILLA|FORGE|SPIGOT|FTB"
	exit
	;;
esac


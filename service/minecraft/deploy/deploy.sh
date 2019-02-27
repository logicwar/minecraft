#!/bin/bash

###############
## CONSTANTS ##
###############
export VERSIONS_JSON="https://launchermeta.mojang.com/mc/game/version_manifest.json"
export INSTALL_DIR="/opt/minecraft/data"

######################################################################### 
# Function : installJAVA
# Purpose  : Install JAVA 8
# Remarks  : -
######################################################################### 
function installJAVA {
	# Download and install latest jre 8 (Java)
	echo "**** Install JAVA JRE 8 ****"
	cd /opt
	wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jre-8u201-linux-x64.tar.gz
	tar -zxvf jre-8u201-linux-x64.tar.gz
	update-alternatives --install /usr/bin/java java /opt/jre1.8.0_201/bin/java 1
	echo "**** cleanup ****"
	rm jre-8u201-linux-x64.tar.gz
}


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
	installJAVA
	exec /sbin/setuser docker /container/service/minecraft/deploy/deploy_SPIGOT.sh
	;;

  FORGE|forge)
	installJAVA
	exec /sbin/setuser docker /container/service/minecraft/deploy/deploy_FORGE.sh
	;;

  FTB|ftb)
	installJAVA
	exec /sbin/setuser docker /container/service/minecraft/deploy/deploy_FTB.sh
	;;

  VANILLA|vanilla)
	installJAVA
	exec /sbin/setuser docker /container/service/minecraft/deploy/deploy_VANILLA.sh
	;;

  POCKETMINE|pocketmine)
	echo "**** Install extra Dependencies ****"
	apt-get update
	apt-get install --no-install-recommends -y \
		make \
		autoconf \
		automake \
		m4 \
		bzip2 \
		bison \
		g++ \
		libtool-bin
	echo "**** cleanup ****"
	apt-get clean
	rm -rf \
		/var/lib/apt/lists/* \	
		/tmp/* \
		/var/tmp/*
	exec /sbin/setuser docker /container/service/minecraft/deploy/deploy_POCKETMINE.sh
	;;

  *)
	echo "Invalid type: '$TYPE'"
	echo "Valid types: VANILLA|FORGE|SPIGOT|FTB|POCKETMINE"
	exit
	;;
esac


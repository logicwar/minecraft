#!/bin/bash

mkdir $INSTALL_DIR/tmp
cd $INSTALL_DIR/tmp
#########################################
##       DOWNLOAD THE FTB MODPACK      ##
#########################################
if [ -z $FTB_SERVER_MODPACK ]; then
	if [ -z $FTB_SERVER_MODPACK_URL ]; then
		# Missing parameters
		echo ""
		echo "ERROR: Missing FTB_SERVER_MODPACK or FTB_SERVER_MODPACK_URL variable"
		echo ""
		echo "       Set FTB_SERVER_MODPACK with the file name of the FTB server modpack"
		echo "       you have downloaded and placed in the /data directory"
		echo "    or"
		echo "       Set FTB_SERVER_MODPACK_URL with the URL of the modpack to download"
		exit
	else
		# Download the FTB ModPack ZIP from provided URL
		echo "[$(date +"%H:%M:%S")] [Container Setup]: Downloading $FTB_SERVER_MODPACK_URL"
		wget -q -O ftb_server.zip $FTB_SERVER_MODPACK_URL
		FTB_SERVER_MODPACK="$(find *.zip)"
		if [ -z $FTB_SERVER_MODPACK ]; then
			echo ""
			echo "ERROR: The Downloaded file is not a zip archive"
			exit			
		fi
	fi
else
	mv $INSTALL_DIR/$FTB_SERVER_MODPACK $INSTALL_DIR/tmp/$FTB_SERVER_MODPACK
fi


#########################################
##       INSTALL THE FTB MODPACK       ##
#########################################
echo "[$(date +"%H:%M:%S")] [Container Setup]: Unpacking the FTB server modpack : $FTB_SERVER_MODPACK ..."
#backup the eula.txt
mv $INSTALL_DIR/eula.txt $INSTALL_DIR/tmp/eula.txt
unzip -o $FTB_SERVER_MODPACK -d $INSTALL_DIR
mv $INSTALL_DIR/tmp/eula.txt $INSTALL_DIR/eula.txt
export FTB_SERVER_START=$INSTALL_DIR/ServerStart.sh
chmod a+x $FTB_SERVER_START
#Clean
cd $INSTALL_DIR
rm -rf $INSTALL_DIR/tmp


#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


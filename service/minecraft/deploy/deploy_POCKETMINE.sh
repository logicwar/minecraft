#!/bin/bash

###############
## CONSTANTS ##
###############
POCKETMINE_DOWNLOAD="https://get.pmmp.io"

#########################################
##   DOWNLOAD AND INSTALL POCKETMINE   ##
#########################################
cd $INSTALL_DIR
curl -sL $POCKETMINE_DOWNLOAD | bash -s -
export PM_SERVER_START=$INSTALL_DIR/start.sh

#########################################
##             FINAL SETUP             ##
#########################################
exec /container/service/minecraft/deploy/deploy_FinalSetup.sh


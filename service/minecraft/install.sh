#!/bin/sh

#########################################
##           CREATE FOLDERS            ##
#########################################
# Create files and directories folders
mkdir -p \
	/opt/minecraft/data \
	/home/minecraft

#########################################
##          SET PERMISSIONS            ##
#########################################
# create a "docker" user
useradd -U -d /home/minecraft docker

# Set the permissions
chown -R docker:docker \
	/opt/minecraft/data \
	/home/minecraft

# Ensure the docker user can export to container ENV
chmod -R 757 /container/environment \

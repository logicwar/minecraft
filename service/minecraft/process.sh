#!/bin/sh

#########################################
##          RUN THE SERVICES           ##
#########################################
#Launch minecraft as "docker" user
cd $INSTALL_DIR
if [ ! -z $FTB_SERVER_START ]; then
	exec /sbin/setuser docker $FTB_SERVER_START
else
	if [ ! -z $PM_SERVER_START ]; then
		exec /sbin/setuser docker $PM_SERVER_START --no-wizard
	else
		exec /sbin/setuser docker java $JVM_XX_OPTS $JVM_OPTS -jar $SERVER nogui
	fi
fi

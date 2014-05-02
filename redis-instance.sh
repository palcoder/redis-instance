#!/bin/bash

#########################################################################
#									#
#		    Redis instance creator v1.0				#
#									#
#	A simple script used to set up multiple Redis instances on	#
#	same machine.						        #
#									#
# 	Written by Mohammed Abdallah <palcoder1@gmail.com>		#
#									#
# 	Distributed under license GPLv3+ GNU GPL version 3 or 		#
#	later <http://gnu.org/licenses/gpl.html>			#
#									#
#########################################################################

# Notes:
#	1.You need to run the script as root.
#	2.This script is tested only on Debian
#	3.This script copy the orginal config of Redis instance

# Usage:
#
#	./redis-instance [instance name] [instance port]
#

# Example:
#
#	./redis-instance session 5412
#
#	Will create an new instance called redis-session listening on
#	the port 5412
#

if [ -z $1 ]; then
	echo -e "\nError: Instance name is required.\n"
	echo -e "usage: redis-instance.sh [instance name] [instance port]\n"
	exit 1
fi

if [ -z $2 ]; then
	eecho "\nError: Instance port is required.\n"
	echo -e "usage: redis-instance.sh [instance name] [instance port]\n"
	exit 1
fi

# default values
CONFIG_ORG="/etc/redis/redis.conf"
PIDFILE_ORG="/var/run/redis/redis-server.pid"
LOGFILE_ORG="/var/log/redis/redis-server.log"
DATA_ORG="/var/lib/redis"
INIT_ORG="/etc/init.d/redis-server"

# new values
CONFIG_NEW="/etc/redis/redis-$1.conf"
PIDFILE_NEW="/var/run/redis/redis-$1.pid"
LOGFILE_NEW="/var/log/redis/redis-$1.log"
DATA_NEW="/var/lib/redis-$1"
INIT_NEW="/etc/init.d/redis-$1"

#########################################################################

echo 'Creating a new Redis instance ...'

# copy a new config file
echo ' >>> Copying config file.'

cp "$CONFIG_ORG" "$CONFIG_NEW"

# change config values
echo ' >>> Changing config values.'

sed -i "s/port 6379/port $2/g" "$CONFIG_NEW"
sed -i "s|pidfile $PIDFILE_ORG|pidfile $PIDFILE_NEW|g" "$CONFIG_NEW"
sed -i "s|logfile $LOGFILE_ORG|logfile $LOGFILE_NEW|g" "$CONFIG_NEW"
sed -i "s|dir $DATA_ORG|dir $DATA_NEW|g" "$CONFIG_NEW"

# make a new dir for the new instance

echo ' >>> Creating a new directory.'

mkdir "$DATA_NEW"
chown redis:redis "$DATA_NEW"

# Creating init script

echo ' >>> Creating init script.'

cp "$INIT_ORG" "$INIT_NEW"
chmod +x "$INIT_NEW"

sed -i "s|$CONFIG_ORG|$CONFIG_NEW|g" "$INIT_NEW"
sed -i "s|NAME=redis-server|NAME=redis-$1|g" "$INIT_NEW"
sed -i "s|DESC=redis-server|DESC=redis-$1|g" "$INIT_NEW"
sed -i "s|redis-server.pid|redis-$1.pid|g" "$INIT_NEW"

echo ' >>> Register the daemon.'

update-rc.d "redis-$1" defaults

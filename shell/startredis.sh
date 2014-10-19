#!/bin/sh
. ./base.sh
if [ $# != 1 ]; then
	echo "sh startredis.sh config"
	exit
fi
config=$CONF_DIR/$1
oldpath=`pwd`

cd $DS_DIR
redis-server $config &
cd $oldpath

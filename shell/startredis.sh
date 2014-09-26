#! /bin/sh
. ./define.lst
if [ $# -ne 1 ]; then
	echo "usage: sh startredis.sh redis_conf"
	exit;
fi
conf_filename=$1
oldpath=`pwd`
cd $DS_PATH
redis-server $CONF_PATH/$conf_filename 
cd $oldpath


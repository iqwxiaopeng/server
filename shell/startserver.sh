# !/bin/sh
. ./base.sh
conf=$CONF_DIR/skynet.conf
if [ $# = 1 ]; then
	conf=$1
fi
oldpath=`pwd`
log "startserver $SERVERNAME ..."
cd ../skynet
ln -fs skynet $SERVERNAME
./$SERVERNAME $conf &
cd $oldpath
sh onstartserver.sh
log "startserver $SERVERNAME ok"

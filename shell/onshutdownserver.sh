# !/bin/sh
. ./base.sh
log "onshutdownserver"
rm -rf startserver.flag
sh try_backup_log.sh $LOG_DIR

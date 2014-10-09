# !/bin/sh
. ./base.sh
log "onshutdownserver"
sh try_backup_log.sh $LOG_DIR

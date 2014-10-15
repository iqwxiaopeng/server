# !/bin/sh
. ./base.sh
echo "checkerror.sh" >> $SHELL_LOG
tips="$SERVERNAME(id=$SERVERID,ip=$IP)"
python checkerror.py "$ERROR_LOG" "$ERROR_NOTIFY_MAILLIST" "$tips"

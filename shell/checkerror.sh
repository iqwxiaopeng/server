# !/bin/sh
. ./shell.conf
echo "checkerror.sh" >> $SHELL_LOG
tips="$SERVERNAME(id=$SERVERID)"
python checkerror.py "$ERROR_LOG" "$ERROR_NOTIFY_MAILLIST" "$tips"

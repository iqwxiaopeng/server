# !/bin/sh
. ./shell.conf
echo "checkserver.sh" >> $SHELL_LOG
isstart=`ps -ef | grep "$SERVERNAME" | grep "config" | grep -v "grep"`
if [ "$isstart" = "" ]; then
	tips=`printf "$SERVERNAME(id=$SERVERID) shutdown"`
	python sendmail.py "$ERROR_NOTIFY_MAILLIST" "$tips" "$tips"
	rm -rf checkerror.line
fi

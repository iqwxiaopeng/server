# !/bin/sh
. ./shell.conf
crontab -u $USER -r
crontab -u $USER crontab.conf
echo "init crontab ok"


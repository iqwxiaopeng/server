#! /bin/sh
. ./base.sh

if [ $# -lt 1 ]; then
	echo "usage: sh hotfix.sh modname1,..."
	exit 0
fi
log "hotfix $*"
filename=".oscmd.txt"
for modname in $@; do
	echo "hotfix $modname" >> $filename
done




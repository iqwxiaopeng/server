#!/bin/sh
. ./base.sh
killall lua
killall $SERVERNAME
sh onshutdownserver.sh
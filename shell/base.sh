# !/bin/sh
. ./shell.conf

now(){
	echo `date +"%Y-%m-%d %H:%M:%S"`
}

log(){
	printf "[%s] %s\n" "`now`" "$*" >> $SHELL_LOG;
}


# !/bin/sh
. ./base.sh

is_too_big(){
	filename=$1
	--bytes=`du -b "$filename" | awk {'print $1'}`
	bytes = `ls -l "$filename" | awk {'print $5'}`
	_1g=`expr 1024 \* 1024 \* 1024`
	#_1g=1024 # test
	if [ $bytes -ge $_1g ]; then
		echo "1"
	else
		echo "0"
	fi
}

try_backup(){
	filename=$1
	result=`is_too_big "$filename"`
	#echo $result $filename
	if [ "$result" = "1" ]; then
		now=`date +"%Y%m%d%H%M%S"`
		backup_filename=`printf ".%s_%s.bak" "$filename" "$now"`
		log "backup $filename ==> $backup_filename"
		cp -a "$filename" "$backup_filename"
		log "remove $filename"
		rm -rf "$filename"
	fi
}

visit_dir(){
	dirname=$1
	if ! [ -d $dirname ]; then
		exit 0
	fi
	oldpath=`pwd`
	cd "$dirname"
	for filename in $(ls -a); do
		if [ "$filename" = "." ] || [ "$filename" = ".." ]; then
			continue
		fi
		if [ -d "$filename" ]; then
			visit_dir "$filename"
		elif [ -f "$filename" ]; then
			if [ `expr $filename : ^\..*\.bak$` -eq 0 ]; then
				try_backup "$filename"
			fi
		fi
	done
	cd "$oldpath"
}
if [ $# != 1 ]; then
	log "[ERROR] try_backup_log.sh argument != 1"
	exit
fi
log "try_backup_log.sh $1"
visit_dir $1


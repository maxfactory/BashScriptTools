#!/bin/bash
cat /data/dz.txt|while read line
do
	dir=`echo $line | awk -F / '{print $6} ' | awk -F _ '{print $2}'`
	dir_folder="/data/$dir"
	if [ ! -d "$dir_folder" ]; then
		mkdir $dir_folder
	fi
	wget -P $dir_folder $line > /dev/null 2<&1
done
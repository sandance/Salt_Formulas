#!/bin/bash

cnt=0
total_proc=`ls "/usr/lgfwms/mounts/local/" | grep -v celerylogs | wc -l`

for client in `ls "/usr/lgfwms/mounts/local/" | grep -v celerylogs`;
do 
	#echo $client ; 
	status=$(ps -ef | grep  "beat" | grep "$client" | awk -F ' ' '{ print $1  }')
	if [ -n "$status" ];
	then
		cnt=$((cnt + 1))
	fi
	
done

if [[ $cnt -eq $total_proc ]]
then
	echo 1
else
	echo 0
fi


#!/bin/bash
ADB=/full/path/to/adb-linux

function send {
	number=$1
	text=$2
	echo "Sending text to:" $1
	$ADB shell am start -a android.intent.action.SENDTO -d sms:$number --es sms_body "$text" --ez exit_on_sent true
	sleep 1
	$ADB shell input keyevent 22
	sleep 1
	$ADB shell input keyevent 66
}

if [ $# -lt 3 ]
then
	echo -e "Usage: sms SMSTEXT [OPTIONS]\n\nValid options:\nr\tRange from-to\nl\tUse list with one number per line"
	exit 1
fi
text=$1
shift

while getopts "r:l:" flag 
do 
	# Process range
	if [ $flag == "r" ]
	then
		range=$OPTARG
		if [[ $range =~ [0-9]+\-[0-9]+ ]]
		then
			from="${range//\-[0-9]*/}"
			to="${range//[0-9]*\-/}"
			if [ $from -gt $to ]
			then
				tmp=$from
				from=$to
				to=$tmp
			fi
			echo "Processing range from $from to $to."
			while [ $from -le $to ]
			do
				send $from "$text"
				from=$[$from+1]
			done
		else
			echo "'$range' is not a valid range."
		fi		
	fi

	# Process numbers from file
	if [ $flag == "l" ]
	then
		if [ -r $OPTARG ]
		then
			file=$OPTARG
			echo "Processing numbers from file: $file"
			while read line
			do
				if [[ $line =~ [0-9]+ ]]
				then
					send $line "$text"
				else
					echo "'$line' is not a number."
				fi
			done < $file
		else
			echo "No such file or not readable: $OPTARG"
		fi
	fi
done
#!/bin/bash

i3status --config /home/helgi/.i3/i3status.conf | while :
do
	read line
	LG=$(setxkbmap -query | awk '/layout/{print $2}')
	TASK=$(task ls | sed -n '4s/[[:blank:]]\+/ /pg')

	echo "TODO: $TASK | KB $LG | $line" || exit 1
done

#!/bin/bash

i3status --config /home/helgi/.i3/i3status.conf | while :
do
	read line
	LG=$(setxkbmap -query | awk '/layout/{print $2}')
	echo "KB $LG | $line" || exit 1
done

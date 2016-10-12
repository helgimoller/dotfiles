#!/bin/bash
KB_LAYOUT=$(setxkbmap -query | awk '/layout/{print $2}')
if [[ $KB_LAYOUT == "is" ]]; then
       	setxkbmap us 
fi

if [[ $KB_LAYOUT == "us" ]]; then
	setxkbmap is 
fi
pkill -RTMIN+11 i3blocks
xmodmap /home/helgi/.i3/caps2esc.modmap

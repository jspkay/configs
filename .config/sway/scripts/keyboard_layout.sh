#!/bin/bash

Preferences=(it us fr)

active=$(swaymsg -t get_inputs | jq '.[-1].xkb_active_layout_name')

i=0
for el in ${Preferences[@]}
do
	echo $active | grep -i $el > /dev/null
	if [ $? = 0 ]
	then
		printf "It is $el\n"
		current=$i
	else
		printf "Not $el\n"
	fi
	let i=$i+1
done
echo ''

let current=$current+1
if [ $current -ge ${#Preferences[@]} ]
then
	current=0
fi
swaymsg input "type:keyboard" xkb_layout ${Preferences[$current]}
echo ${Preferences[$current]} > present_keyboard_layout

notify-send "Keyboard layout set to ${Preferences[$current]}"

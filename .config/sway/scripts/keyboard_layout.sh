#!/bin/bash

swaymsg -m -t subscribe "['input']" | jq --unbuffered -r ".input.xkb_active_layout_name" | (
  prev_layout=""
  while read new_layout; do
    # echo $prev_layout $new_layout
    if [ "$new_layout" != "$prev_layout" ]; then
      notify-send "${new_layout}" "Keyboard layout changed to $new_layout"
      pkill -RTMIN+1 waybar
      prev_layout=$new_layout
    fi
  done
)

exit 0

# old inefficient version
Preferences=(it us fr)

active=$(swaymsg -t get_inputs | jq '.[-1].xkb_active_layout_name')

i=0
for el in ${Preferences[@]}; do
  echo $active | grep -i $el >/dev/null
  if [ $? = 0 ]; then
    printf "It is $el\n"
    current=$i
  else
    printf "Not $el\n"
  fi
  let i=$i+1
done
echo ''

let current=$current+1
if [ $current -ge ${#Preferences[@]} ]; then
  current=0
fi
swaymsg input "type:keyboard" xkb_layout ${Preferences[$current]}
echo ${Preferences[$current]} >present_keyboard_layout
pkill -RTMIN+1 waybar
notify-send "Keyboard layout set to ${Preferences[$current]}"

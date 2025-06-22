#!/bin/zsh

ciao=$(pactl -f json list sinks | jq -r '.[] | .description')
echo $BEMENU_OPTS
# selected=$(echo $ciao | bemenu \
#  "$BEMENU_OPTS" \
#  -l 10 \
#  -p "Audio Selection" \
#  -w \
#  -n \
#  -c \
#  -H 20 \
#  --fn "DejaVu Sans Mono 15" \
#  --tb "#E8215A" --tf "#FFFFFF" \
#  --fb "#FFFFFF" --ff "#E8215A" \
#  --nb "#E8215A" --nf "#FFFFFF" \
#  --ab "#E8215A" --af "#ffffff" \
#  --hf "#000000" --hb "#ffffff" \
#  --sb "#0000ff" --sf "#0000ff" \
#  --scb "#0000ff" --scf "#FFFFFF")
selected=$(echo $ciao | bemenu -l 10 -p "Audio Selection")


sink_name=$(pactl -f json list sinks | jq -r --arg sink_pretty_name "$selected" '.[] | select(.description == $sink_pretty_name) | .name')

if [ -n "$sink_name" ]; then
  pactl set-default-sink "$sink_name" && notify-send "Audio" "Audio switched to $selected"
else
  notify-send "Audio" "Audio NOT switched"
fi

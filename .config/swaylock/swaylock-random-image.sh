#!/bin/bash

LIST=($HOME/Pictures/wallpapers/*)
# echo "LIST has lengtht ${#LIST[@]}"
IMAGE=${LIST[$RANDOM % ${#LIST[@]}]}

exec swaylock --image $IMAGE "$@"

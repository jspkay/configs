#!/bin/zsh

videos=$(ls ~/Videos/)
choice=$(echo $videos | bemenu)
echo $choice
if [[ $choice == "" ]]
then 
  exit 0
fi
exec mpv ~/Videos/$choice &
exit 0

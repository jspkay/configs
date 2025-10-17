#!/bin/zsh

homescreen=$(randr | grep "15B1")
if [ $? -eq 0 ]; then # We are at home 
  echo "We are in"
  out=$(echo $homescreen | cut -d' ' -f1)
  randr --output $out --right-of eDP-1
fi



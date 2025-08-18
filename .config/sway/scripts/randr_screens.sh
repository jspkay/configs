#!/bin/zsh

homescreen=$(randr | grep "15B1")
if [ $? ]; then
  out=$(echo $homescreen | cut -d' ' -f1)
  randr --output $out --right-of eDP-1
fi

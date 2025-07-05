#!/bin/bash

# This script is meant to toggle "do not disturb" mode, by killing and respwaning the notification daemon mako.

if [ $# -ne 1 ]; then
  echo "Please execute the script with one argument among 'spawn', 'kill', 'toggle' "
  exit 1
fi

if [ $1 = "spawn" ]; then
  exec mako &
fi

if [ $1 = "kill" ]; then
  killall -1 mako
  exit 0
fi

if [ $1 == "toggle" ]; then
  ps -e | grep "mako"
  if [ $? -eq 0 ]; then
    killall mako
  else
    exec mako &
  fi
fi

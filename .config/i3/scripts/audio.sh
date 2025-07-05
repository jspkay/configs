#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 [command], were [command] can be up, down, toggle"
  exit 0
fi

case "$1" in
'up')
  echo up
  ;;
'down')
  echo down
  ;;
'toggle')
  echo toggle
  ;;
*)
  echo default
  ;;
esac

if [ $1 = '!p' ]; then
  echo "ciao"
fi

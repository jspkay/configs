#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script

setxkbmap it
xinput set-prop 13 "libinput Natural Scrolling Enabled" 1
xinput set-prop 13 "libinput Tapping Enabled" 1
xinput set-prop 13 "libinput Tapping Drag Enabled" 1
xinput set-prop 13 "libinput Accel Speed" 0.25

# Set screens at work
xrandr --output eDP-1 --auto --scale 0.75x0.75
xrandr --output DP-2-1 --auto --left-of eDP-1
xrandr --output DP-2-2 --auto --left-of DP-2-1 --rotate left

# Duplicates for the other usbc
xrandr --output DP-1-1 --auto --left-of eDP-1
xrandr --output DP-1-2 --auto --left-of DP-1-1 --rotate left

exec i3

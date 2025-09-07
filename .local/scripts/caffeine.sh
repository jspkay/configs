#!/bin/zsh

ps -C swayidle -o pid,command | tail -n +2 > /tmp/caffeine.1
ps -C swayidle -o pid,command | tail -n +2 | grep sleep > /tmp/caffeine.2
pid=$(comm /tmp/caffeine.{1,2} -3 | cut -d' ' -f1)

echo swayidle PID: $pid
if [ ! -z $pid ]; then # swayidle is detected, caffeine is not active 
  echo caffeine is inactive
  kill $pid
  echo "Caffeine"
  notify-send "Caffeine" "The laptop won't go to sleep on its own."
else
  print "Infusion"
  notify-send "Infusion" "The laptop is allowed to sleep now."
  exec swayidle -w \
    timeout 300 '$lock -f' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' &
fi

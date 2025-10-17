#!/bin/zsh

# Old unreliable version...
ps -C swayidle -o pid,command | tail -n +2 | sort > /tmp/caffeine.1
ps -C swayidle -o pid,command | tail -n +2 | grep sleep | sort > /tmp/caffeine.2
pid=$(comm /tmp/caffeine.{1,2} -3 | cut -d' ' -f1)

echo swayidle PID: $pid
if [ ! -z $pid ]; then # swayidle is detected, caffeine is not active 
fi

#### end old version 
# New version, with sleeptimer 
ps -e | grep sleeptimer # we search for sleeptimer
out=$?
echo $out
if [ $out = 0 ]; then # if it is found, we need to active caffeine
  echo caffeine is inactive
  killall sleeptimer
  echo "Caffeine"
  notify-send "Caffeine" "The laptop won't go to sleep on its own."
else
  print "Infusion"
  notify-send "Infusion" "The laptop is allowed to sleep now."
  exec ./sleeptimer.sh &
fi

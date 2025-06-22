#!/bin/zsh

a=0
while [[ 0 ]]; do
  echo -n "Recording..."
  arecord -d 3 "/tmp/recording$a.wav" --quiet
  echo "Stop."
  transcripted=$(
    curl 127.0.0.1:8009/inference \
      -H "Content-Type: multipart/form-data" \
      -F file="/tmp/recording$a.wav" \
      -F temperature="0.0" \
      -F temperature_inc="0.2" \
      -F response_format="text" --no-progress-meter &
  )
  a=$(( (a + 1) % 2 ))
  echo $a
  echo $transcripted
done

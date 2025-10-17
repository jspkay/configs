#!env sh

newname=/tmp/sleeptimer
rm /tmp/sleeptimer
ln -s $(which swayidle) $newname

exec $newname -w \
  timeout 300 '$lock -f' \
  timeout 600 'swaymsg "output * dpms off"' \
  resume 'swaymsg "output * dpms on"'

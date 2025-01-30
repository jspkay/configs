import os 
import sys

print(sys.argv)
MAX = 130
current = os.popen("pactl get-sink-volume @DEFAULT_SINK@").read()
current = current.split("/ ")[1].split("/")[0].replace("%", "")
current = int(current)

ismute = os.popen("pactl get-sink-mute @DEFAULT_SINK@").read()
ismute = True if "yes" in ismute else False

print(sys.argv[1])

if sys.argv[1] == "plus":
    if current >= MAX:
        os.system(f"pactl set-sink-volume @DEFAULT_SINK@ {MAX}%")
    else:
        os.system(f"pactl set-sink-volume @DEFAULT_SINK@ +5%")
    
    if ismute:
        os.system(f"pactl set-sink-mute @DEFAULT_SINK@ no")

elif sys.argv[1] == "minus":
    os.system(f"pactl set-sink-volume @DEFAULT_SINK@ -5%")
elif sys.argv[1] == "toggleMute":
    os.system(f"pactl set-sink-mute @DEFAULT_SINK@ toggle")
else:
    raise Exception("Error! Argument not compatible!")

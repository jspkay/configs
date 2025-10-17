#!/bin/python3

import os 
import sys
import subprocess 

HOME = os.environ["HOME"]
PATH = os.environ["PATH"] 
# os.environ["PATH"] = PATH + f":{HOME}/miniforge3/bin"
print(os.environ["PATH"])

pactl = f"{HOME}/miniforge3/bin/pactl"

pactlP = subprocess.run([f"{HOME}/miniforge3/bin/pactl", "get-sink-volume", "@DEFAULT_SINK@"], encoding="utf8", capture_output=True)
print("pactl working: ", pactlP.stdout)
print("pactl working (stderr): ", pactlP.stderr)


print(sys.argv)
MAX = 130
FTH = 10 # FINE THRESHOLD: beyond this point, the volume has finer control
current = os.popen(f"{pactl} get-sink-volume @DEFAULT_SINK@").read()
current = current.split("/ ")[1].split("/")[0].replace("%", "")
current = int(current)

ismute = os.popen(f"{pactl} get-sink-mute @DEFAULT_SINK@").read()
print("ismute: ", ismute)
ismute = True if "yes" in ismute else False

print(sys.argv[1])

if sys.argv[1] == "plus":
    if current >= MAX:
        os.system(f"{pactl} set-sink-volume @DEFAULT_SINK@ {MAX}%")
    if current < FTH:
        os.system(f"{pactl} set-sink-volume @DEFAULT_SINK@ +1%")
    else:
        os.system(f"{pactl} set-sink-volume @DEFAULT_SINK@ +5%")
    
    if ismute:
        os.system(f"{pactl} set-sink-mute @DEFAULT_SINK@ no")

elif sys.argv[1] == "minus":
    if current <= FTH+1:
        os.system(f"{pactl} set-sink-volume @DEFAULT_SINK@ -1%")
    else:
        os.system(f"{pactl} set-sink-volume @DEFAULT_SINK@ -5%")
elif sys.argv[1] == "toggleMute":
    print("I'm doing it !!!!")
    os.system(f"{pactl} set-sink-mute @DEFAULT_SINK@ toggle")
else:
    raise Exception("Error! Argument not compatible!")

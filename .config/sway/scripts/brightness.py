import os 
import sys

print(sys.argv)
MAX = int(os.popen("brightnessctl m").read())
current = os.popen("brightnessctl g").read()
current = int(current)/MAX
print(current)
if sys.argv[1] == "plus":
    if current == 0.01:
        os.system("brightnessctl s 5%")
    elif current <= 0.96:
        os.system("brightnessctl s +5%")
elif sys.argv[1] == "minus":
    if current >= 0.06:
        os.system("brightnessctl s 5%-")
    else:
        os.system("brightnessctl s 1%")
else:
    raise Exception("Error! Argument not compatible!")

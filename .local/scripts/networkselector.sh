#!/usr/bin/env zsh

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FIELDS=IN-USE,SSID,SECURITY,RATE,CHAN,BARS
POSITION=0
YOFF=0
XOFF=0
FONT="DejaVu Sans Mono 13"

MAXLINENUM=12

if [ -r "$DIR/config" ]; then
	source "$DIR/config"
elif [ -r "$HOME/.config/rofi/wifi" ]; then
	source "$HOME/.config/rofi/wifi"
else
	echo "WARNING: config file not found! Using default values."
fi

exec -a "System" notify-send "WiFi Menu" "Scanning WiFi Networks..." -t 5000 &
LIST=$(nmcli --fields "$FIELDS" device wifi list --rescan yes | sed '/^--/d' | tail -n +2 )
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(($(echo "$LIST" | wc -l)+2))
# Gives a list of known connections so we can parse it later
# KNOWNCON=$(nmcli --fields "NAME" connection show)
KNOWNCON=$(nmcli -g NAME con show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ ! -z $CURRSSID ]]; then
	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc )
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt "$MAXLINENUM" ] && [[ "$CONSTATE" =~ "enabled" ]]; then
	LINENUM=$MAXLINENUM
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	LINENUM=1
fi


if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="toggle on"
fi


CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | bemenu -p "Wi-Fi SSID: " -n -H 20 -l "$LINENUM" --fn "$FONT" -W -"$RWIDTH")
if [[ $CHENTRY == "" ]]; then 
  notify-send "WiFi Menu" "Operation Cancelled."
  exit 0
fi
# CHENTRY=$(echo -e "$TOGGLE\nmanual\n$LIST" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH")
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $2}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "manual" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -p "Manual Entry: " -font "$FONT" -lines 1)
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

elif [ "$CHENTRY" = "toggle on" ]; then
	nmcli radio wifi on

elif [ "$CHENTRY" = "toggle off" ]; then
	nmcli radio wifi off

else

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
  notify-send "WiFi Menu" "Connecting to '$CHSSID'"
  echo "$KNOWNCON" | grep "$CHSSID" --color=auto
  echo "$CHSSID"
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") =~ "$CHSSID" ]]; then
    NAME=$(echo "$KNOWNCON" | grep "$CHSSID")
    echo "Found connection for '$NAME'"
    notify-send "WiFi Menu" "Found connection for '$NAME'"
		nmcli con up "$NAME"
    if [[ -n $? ]]
    then notify-send "WiFi Menu" "Error in setting up the connection..."
    fi
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "if connection is stored, hit enter" |  bemenu -p "password: " -l 1 --fn "$FONT" )
			# WIFIPASS=$(echo "if connection is stored, hit enter" | rofi -dmenu -p "password: " -lines 1 -font "$FONT" )
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi

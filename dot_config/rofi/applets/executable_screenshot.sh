#!/usr/bin/env bash
# Based on Screenshot by Aditya Shakya (adi1090x)

# Theme Elements
prompt='Screenshot'
mesg="DIR: ~/Pictures/Screenshots"

# Options
option_1=""
option_2=""
option_3=""
option_4=""
option_5=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str 'textbox-prompt-colon {str: "";}' \
    -theme-str 'inputbar {background-image: url("/tmp/screenshot.png", width);}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme screenshot.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
dir="$(xdg-user-dir PICTURES)/Screenshots"
before=$(ls "$dir" -1q | wc -l)
temp="/tmp/screenshot.png"
grim -o $(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name') ${temp}

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
	after=$(ls "$dir" -1q | wc -l)
	notify_cmd_shot='dunstify -u low -i gnome-screenshot Rofishot --replace=699'
	if [[ "$after" -gt "$before" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
	else
		${notify_cmd_shot} "Screenshot Not Saved."
	fi
}

# Grab Window Wayland 
function grab_window() {
    local monitors=`hyprctl -j monitors`
    local clients=`hyprctl -j clients | jq -r '[.[] | select(.workspace.id | contains('$(echo $monitors | jq -r 'map(.activeWorkspace.id) | join(",")')'))]'`
    # Generate boxes for each visible window and send that to slurp
    # through stdin
    local boxes="$(echo $clients | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"')"
    slurp -r <<< "$boxes"
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Taking shot in : $sec"
		sleep 1
	done
}


# take shots
shotnow () {
	swappy -f ${temp}
	notify_view
}

shot5 () {
	countdown '5'
	grim -o $(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name') - | swappy -f -
  notify_view
}

shot10 () {
	countdown '10'
	grim -o $(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name') - | swappy -f -
	notify_view
}

shotwin () {
	sleep 0.2 && grim -g "$(grab_window)" - | convert - -trim +repage - | swappy -f -
	notify_view
}

shotarea () {
	sleep 0.2 && grim -g "$(slurp -d -b '#ebdbb244' -c '#FB4934FF' -B '#FB4934FF' -F 'Hack Nerd Font' -w '1')" - | swappy -f -
  notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac



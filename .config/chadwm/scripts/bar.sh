#!/bin/zsh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/onedark

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$green^^b$black^  "
  printf "^c$green^ $cpu_val"
}

battery() {
  printf "^b$black^  " # adds spaces in the front so the battery icon doesn't get covered
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"

	case "$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)" in
	Discharging) printf "^c$blue^   $get_capacity" ;;
	Charging) printf "^c$blue^ 󱐋  $get_capacity" ;;
	Full) printf "^c$blue^   $get_capacity" ;;
  esac
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(brightnessctl -m | cut -d',' -f4 | tr -d '%')
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$green^  "
	printf "^c$green^^b$black^ $(date '+%a %b %d') "
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done

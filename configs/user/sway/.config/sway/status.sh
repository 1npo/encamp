date_formatted=$(date "+%a %Y-%m-%d %I:%M:%S %p")
battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

echo "$battery_status @ $battery_percent% 🔋" $date_formatted

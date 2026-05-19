#!/bin/bash
while true; do
    uptime_formatted=$(uptime | cut -d ',' -f1 | cut -d ' ' -f4,5)
    date_formatted=$(date "+%a %F %H:%M")
    battery_status=$(cat /sys/class/power_supply/BAT0/status)
    battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)%

    echo "$uptime_formatted ↑ $battery_status $battery_percentage 🔋 $date_formatted"
    sleep 5
done

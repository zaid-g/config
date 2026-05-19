#!/bin/bash
for output in $(swaymsg -t get_outputs | grep -o '"name": "[^"]*"' | awk -F'"' '{print $4}' | grep -v eDP-1); do
    swaymsg output "$output" mirror eDP-1
done

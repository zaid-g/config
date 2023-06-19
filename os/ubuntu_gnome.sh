#!/bin/bash
# run this file without sudo

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

## keyboard settings
# swap capslock with escape
dconf write "/org/gnome/desktop/input-sources/xkb-options" "[ 'caps:swapescape']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

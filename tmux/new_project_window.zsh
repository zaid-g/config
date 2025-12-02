#!/usr/bin/env zsh
source ~/.zshrc
MKT "$1"
tmux split-window -h
bash ~/doc/config/tmux/rename_window.sh
GI
TN
QQ

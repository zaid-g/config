#!/usr/bin/env zsh
source ~/.zshrc
MKJ "$1"
tmux split-window -h
TB
tmux send-keys -t 1 'VB' Enter
tmux split-window -v
bash ~/doc/config/tmux/rename_window.sh
QQ

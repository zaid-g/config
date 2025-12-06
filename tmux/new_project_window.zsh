#!/usr/bin/env zsh
source ~/.zshrc
MKJ "$1"
tmux split-window -h
bash ~/doc/config/tmux/rename_window.sh
TB
QQ

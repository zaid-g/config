#!/usr/bin/env bash

p=$(tmux display-message -p "#{pane_current_path}")

# Get actual home directory path
home=$(realpath ~)

# Strip home path if present
r="${p#$home/}"

# Skip first folder, keep everything from second onwards  
IFS=/ read -r _ name <<< "$r"

# Truncate to 15 chars
[[ ${#name} -gt 15 ]] && name="${name:0:12}…"

# Rename tmux window
tmux rename-window "$name"

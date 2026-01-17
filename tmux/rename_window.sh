#!/usr/bin/env bash

local last_folder_in_path=$(basename "$(FIND_BRAIN_PARENT_PATH)")

# Truncate to 15 chars
[[ ${#last_folder_in_path} -gt 15 ]] && last_folder_in_path="${last_folder_in_path:0:12}…"

# Rename tmux window
tmux rename-window "$last_folder_in_path"

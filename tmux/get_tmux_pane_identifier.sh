#!/bin/sh
set -eu

socket_path="$1"
pane_id="$2"
current_command="$3"
current_path="$4"
mode="${5:-clipboard}"

case "$current_path" in
    "$HOME"/*|"$HOME") short_path="~${current_path#"$HOME"}" ;;
    *)                 short_path="$current_path" ;;
esac

pane_identifier="tmux pane $pane_id on server $socket_path (running $current_command in $short_path)"

case "$mode" in
    popup)
        popup_file="$(mktemp /tmp/tmux_pane_identifier.XXXXXX)"
        printf '%s\n' "$pane_identifier" > "$popup_file"
        tmux -S "$socket_path" display-popup -w 90% -h 30% -E \
            "cat '$popup_file'; rm -f '$popup_file'; printf '\n[Enter to close] '; read -r _"
        ;;
    print)
        printf '%s\n' "$pane_identifier"
        ;;
    *)
        if ! printf '%s' "$pane_identifier" | tmux -S "$socket_path" load-buffer -w - 2>/dev/null; then
            printf '%s' "$pane_identifier" | tmux -S "$socket_path" load-buffer -
        fi
        if command -v termux-clipboard-set >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | termux-clipboard-set
        elif command -v pbcopy >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | pbcopy
        elif command -v clip.exe >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | clip.exe
        elif command -v wl-copy >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | wl-copy
        elif command -v xclip >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | xclip -selection clipboard
        elif command -v xsel >/dev/null 2>&1; then
            printf '%s' "$pane_identifier" | xsel --clipboard --input
        fi
        tmux -S "$socket_path" display-message "copied identifier of pane $pane_id ($current_command)"
        ;;
esac

#!/bin/sh
set -eu

socket_dir="${TMUX_RESOURCE_SOCKET_DIR:-${TMUX_TMPDIR:-/tmp}/tmux-$(id -u)}"

resourced=0
failed=0
dead=0
for socket in "$socket_dir"/*; do
    [ -S "$socket" ] || continue
    if ! tmux -S "$socket" list-sessions >/dev/null 2>&1; then
        dead=$((dead + 1))
        continue
    fi
    if tmux -S "$socket" source-file ~/.tmux.conf; then
        resourced=$((resourced + 1))
    else
        failed=$((failed + 1))
    fi
done

message="tmux config re-sourced in $resourced session(s)"
if [ "$failed" -gt 0 ]; then
    message="$message, $failed FAILED (config error shown above)"
fi
if [ "$dead" -gt 0 ]; then
    message="$message, $dead dead socket(s) skipped"
fi

if [ -n "${TMUX:-}" ]; then
    tmux display-message "$message"
else
    printf '%s\n' "$message"
fi

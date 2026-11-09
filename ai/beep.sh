#!/bin/sh
# Play a short notification sound. Called by the kiro and claude Stop hooks.

# inside tmux: ring the bell on the owning pane so tmux flags its window in the
# status bar (window-status-bell-style) until that window is selected
if [ -n "$TMUX_PANE" ] && command -v tmux >/dev/null 2>&1; then
    pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
    [ -n "$pane_tty" ] && printf '\a' > "$pane_tty"
fi

if [ "$(uname)" = "Darwin" ]; then
    afplay /System/Library/Sounds/Glass.aiff
elif command -v paplay >/dev/null 2>&1; then
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga
else
    printf '\a'
fi

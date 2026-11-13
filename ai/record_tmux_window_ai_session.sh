#!/bin/sh
# Stop-hook helper for kiro and claude code: remembers which tmux window a
# session runs in. Reads the hook's stdin JSON (session_id, cwd) and appends
#   <datetime> <tool> <session_id> <window name> <window position>   (tab-separated)
# to <brain parent>/brain/ai/tmux_windows_ai_sessions.tsv, only when the window name
# or position for that session changed. Latest line per session wins.
# Usage: record_tmux_window_ai_session.sh <kiro|claude> < hook_input.json
tool="$1"
[ -n "$TMUX_PANE" ] || exit 0

parsed=$(python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("session_id","")); print(d.get("cwd",""))' 2>/dev/null)
session_id=$(printf '%s\n' "$parsed" | sed -n 1p)
cwd=$(printf '%s\n' "$parsed" | sed -n 2p)
[ -n "$session_id" ] && [ -n "$cwd" ] || exit 0

# lets TMUX_CLAUDE_FORK_NEW_WINDOW find the session running in this pane
[ "$tool" = "claude" ] && tmux set-option -p -t "$TMUX_PANE" @claude_session_id "$session_id" 2>/dev/null

window_name=$(tmux display-message -p -t "$TMUX_PANE" '#{window_name}' 2>/dev/null) || exit 0
window_position=$(tmux display-message -p -t "$TMUX_PANE" '#{window_index}' 2>/dev/null) || exit 0

brain_parent_path="$cwd"
while [ "$brain_parent_path" != "/" ] && [ ! -d "$brain_parent_path/brain" ]; do
    brain_parent_path=$(dirname "$brain_parent_path")
done
[ -d "$brain_parent_path/brain" ] || exit 0

tmux_windows_ai_sessions_file="$brain_parent_path/brain/ai/tmux_windows_ai_sessions.tsv"
last_window=$(awk -F'\t' -v tool="$tool" -v id="$session_id" \
    '$2 == tool && $3 == id { last = $4 "\t" $5 } END { print last }' "$tmux_windows_ai_sessions_file")
current_window=$(printf '%s\t%s' "$window_name" "$window_position")
[ "$last_window" = "$current_window" ] && exit 0
printf '%s\t%s\t%s\t%s\t%s\n' "$(date +%Y_%m_%d-%H_%M_%S)" "$tool" "$session_id" "$window_name" "$window_position" \
    >> "$tmux_windows_ai_sessions_file"

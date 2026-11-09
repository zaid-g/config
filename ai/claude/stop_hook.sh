#!/bin/sh
# Claude Code Stop hook: record session -> tmux window name, then beep.
hook_input=$(cat)
printf '%s' "$hook_input" | ~/doc/config/config/ai/record_tmux_window_ai_session.sh claude
exec ~/doc/config/config/ai/beep.sh

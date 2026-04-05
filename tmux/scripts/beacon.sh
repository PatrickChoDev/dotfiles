#!/usr/bin/env bash
# Flash the active pane border, then restore based on current focus mode.
# Triggered by pane-focus-in in Beacon mode.

# Flash: bright border for 0.4s
tmux set -gF pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_peach}"
sleep 0.4

# Restore to normal (beacon mode keeps default borders at rest)
tmux set -gF pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"

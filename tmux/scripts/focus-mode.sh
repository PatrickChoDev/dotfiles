#!/usr/bin/env bash
# Cycle through 3 focus modes (prefix+F):
#   0 = Off     — default borders, no dim
#   1 = Dim     — inactive panes: dim border + dim bg (bg works for terminals only)
#   2 = Beacon  — flash active pane border on switch, then restore
#
# Pane border changes work over neovim (tmux-layer rendering).
# window-style bg dim is a bonus for non-nvim panes.

mode=$(tmux show -gv @focus_mode 2>/dev/null)
mode=${mode:-0}
next=$(( (mode + 1) % 3 ))

# Always clear the beacon hook before switching modes
tmux set-hook -gu pane-focus-in 2>/dev/null || true

case $next in
  0)
    # Restore everything to the config defaults
    tmux set -gF pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
    tmux set -gF pane-border-style        "bg=#{@thm_bg},fg=#{@thm_surface_0}"
    tmux set -g  window-style        default
    tmux set -g  window-active-style default
    tmux display-message "Focus: OFF"
    ;;
  1)
    # Dim: bright active border, near-invisible inactive border
    # + dim bg for terminal (non-nvim) panes
    tmux set -gF pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_blue}"
    tmux set -gF pane-border-style        "bg=#{@thm_mantle},fg=#{@thm_surface_0}"
    tmux set -gF window-style        "bg=#{@thm_mantle},fg=#{@thm_subtext_0}"
    tmux set -gF window-active-style "bg=#{@thm_bg},fg=#{@thm_fg}"
    tmux display-message "Focus: DIM"
    ;;
  2)
    # Beacon: no persistent dim, but flash active border on every pane switch
    tmux set -gF pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
    tmux set -gF pane-border-style        "bg=#{@thm_bg},fg=#{@thm_surface_0}"
    tmux set -g  window-style        default
    tmux set -g  window-active-style default
    tmux set-hook -g pane-focus-in "run-shell '~/.tmux/scripts/beacon.sh'"
    tmux display-message "Focus: BEACON"
    ;;
esac

tmux set -g @focus_mode "$next"

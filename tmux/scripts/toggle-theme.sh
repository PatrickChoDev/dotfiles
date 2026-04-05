#!/usr/bin/env bash
# Manually toggle catppuccin flavor between mocha (dark) and latte (light),
# then reload the tmux config so the change takes effect immediately.

current=$(tmux show -gv @catppuccin_flavor 2>/dev/null)

if [ "$current" = "mocha" ]; then
  next="latte"
else
  next="mocha"
fi

tmux set -g @catppuccin_flavor "$next"
tmux source-file ~/.tmux.conf
tmux display-message "Theme: $next"

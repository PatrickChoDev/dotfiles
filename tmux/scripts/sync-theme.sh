#!/usr/bin/env bash
# Sync tmux Catppuccin flavor with the current macOS appearance.

set -euo pipefail

desired_flavor="$("$HOME/.tmux/scripts/detect-theme.sh" 2>/dev/null || true)"
case "$desired_flavor" in
  mocha | latte) ;;
  *) exit 0 ;;
esac

current_flavor="$(tmux show-option -gqv @catppuccin_flavor 2>/dev/null || true)"
if [ "$current_flavor" = "$desired_flavor" ]; then
  exit 0
fi

tmux wait-for -L theme-sync
trap 'tmux wait-for -U theme-sync' EXIT

current_flavor="$(tmux show-option -gqv @catppuccin_flavor 2>/dev/null || true)"
if [ "$current_flavor" = "$desired_flavor" ]; then
  exit 0
fi

tmux set-option -g @catppuccin_flavor "$desired_flavor"

for opt in $(tmux show-options -g | awk '/^@thm_/{print $1}'); do
  tmux set-option -gqu "$opt"
done

tmux run-shell "$HOME/.tmux/plugins/catppuccin/catppuccin.tmux"

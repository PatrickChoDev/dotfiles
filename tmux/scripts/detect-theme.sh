#!/usr/bin/env bash
# Detects macOS light/dark mode and sets @catppuccin_flavor accordingly.
# Prints the flavor name to stdout.

# osascript is the most reliable way to read macOS appearance from any process
is_dark=$(osascript -e 'tell application "System Events" to tell appearance preferences to return dark mode' 2>/dev/null)

if [ "$is_dark" = "true" ]; then
  echo "mocha"
else
  echo "latte"
fi

#!/usr/bin/env bash
# Toggle macOS Dark Mode — the single source of truth for all theme switching.
# Ghostty reads system theme automatically. tmux, nvim, and claude-code are
# explicitly refreshed after the OS toggle.

# ── 1. Detect current macOS appearance ──────────────────────────────────────
is_dark=$(osascript -e 'tell application "System Events" to tell appearance preferences to return dark mode' 2>/dev/null)

if [ "$is_dark" = "true" ]; then
  next_flavor="latte"
  next_os_dark="false"
  next_claude_theme="light"
else
  next_flavor="mocha"
  next_os_dark="true"
  next_claude_theme="dark"
fi

# ── 2. Toggle macOS Dark Mode ────────────────────────────────────────────────
# Ghostty (window-theme=system) will auto-switch its terminal palette,
# which makes fzf-tab and lsd follow for free.
osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to $next_os_dark" 2>/dev/null

# ── 3. Reload tmux ───────────────────────────────────────────────────────────
tmux set -g @catppuccin_flavor "$next_flavor"
tmux source-file ~/.tmux.conf
tmux set -gu @catppuccin_flavor
~/.tmux/scripts/sync-theme.sh

# ── 4. Toggle claude-code theme ──────────────────────────────────────────────
settings="$HOME/.claude/settings.json"
if [ -f "$settings" ]; then
  python3 - "$settings" "$next_claude_theme" <<'EOF'
import json, sys
path, theme = sys.argv[1], sys.argv[2]
with open(path) as f:
  d = json.load(f)
d['theme'] = theme
with open(path, 'w') as f:
  json.dump(d, f, indent=2)
  f.write('\n')
EOF
fi

tmux display-message "Theme: $next_flavor"

# === fzf-tab (must come AFTER compinit) ===
source "$ZSH_HOME/plugins/fzf-tab/fzf-tab.plugin.zsh"

# === Completion Appearance ===
zstyle ':completion:*' group-name ''
zstyle ':fzf-tab:*' single-group no

# Colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
[[ -z "$LS_COLORS" ]] && zstyle ':completion:*' list-colors 'di=34:fi=0:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31'

zstyle ':fzf-tab:*' ansi true
zstyle ':fzf-tab:*' fzf-command 'ftb-tmux-popup'
zstyle ':fzf-tab:*' fzf-flags '--height=~80%' '--layout=reverse'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' group yes
zstyle ':fzf-tab:*' popup-min-width 50
zstyle ':fzf-tab:*' popup-pad 2 0
zstyle ':fzf-tab:*' prefix ''

# Git branch/commit preview
zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
  'git log --oneline --graph --color=always $word 2>/dev/null | head -20'

# Directory preview for cd and zoxide
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath 2>/dev/null || ls $realpath'
zstyle ':fzf-tab:complete:z:*'  fzf-preview 'lsd --color=always --icon=always $realpath 2>/dev/null || ls $realpath'

# Process info for kill/killall
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-preview 'ps -p $word -o pid,user,%cpu,%mem,command 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# Env var value preview
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

# File content preview
zstyle ':fzf-tab:complete:(bat|cat|less|nvim|vim):*' fzf-preview \
  'bat --color=always --style=numbers $realpath 2>/dev/null || cat $realpath'

# man page preview
zstyle ':fzf-tab:complete:man:*' fzf-preview 'man $word 2>/dev/null | head -40'

# brew formula/cask info
zstyle ':fzf-tab:complete:brew-(install|info|uninstall):*' fzf-preview 'brew info $word 2>/dev/null'

# SSH host preview
zstyle ':fzf-tab:complete:ssh:*' fzf-preview \
  'grep -A5 "^Host $word" ~/.ssh/config 2>/dev/null || echo "No config entry for $word"'

# Docker container/image previews
zstyle ':fzf-tab:complete:docker-(start|stop|rm|exec|logs|inspect):*' fzf-preview \
  'docker inspect $word 2>/dev/null | jq -r ".[0] | {Name,Status: .State.Status, Image: .Config.Image, Ports: .NetworkSettings.Ports}" 2>/dev/null || docker ps -a --filter name=$word --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" 2>/dev/null'
zstyle ':fzf-tab:complete:docker-rmi:*' fzf-preview \
  'docker image inspect $word 2>/dev/null | jq -r ".[0] | {Tags: .RepoTags, Size: .Size, Created: .Created}" 2>/dev/null || docker images $word 2>/dev/null'

zstyle ':completion:*:*:rustup:*' ignored-patterns '+*'
zstyle ':completion:*:*:rustup:*' list-colors 'no=0:fi=0:*.rs=35:*.toml=36:*.md=32'

# === fzf-tab (must come AFTER compinit) ===
source "$ZSH_HOME/plugins/fzf-tab/fzf-tab.plugin.zsh"

# === Completion Appearance ===
zstyle ':completion:*' group-name ''
zstyle ':fzf-tab:*' single-group no

# Colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
[[ -z "$LS_COLORS" ]] && zstyle ':completion:*' list-colors 'di=34:fi=0:ln=35:pi=33:so=32:bd=34;46:cd=34;43:ex=31'

# UI formatting
# === fzf-tab specific config ===
zstyle ':fzf-tab:*' ansi true
zstyle ':fzf-tab:*' fzf-command 'ftb-tmux-popup'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' group yes

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --graph --color=always {} | head -20'

# Directory preview for cd and zoxide
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --icon=always $realpath 2>/dev/null || ls $realpath'
zstyle ':fzf-tab:complete:z:*'  fzf-preview 'lsd --color=always --icon=always $realpath 2>/dev/null || ls $realpath'

# Process info for kill/killall
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-preview 'ps -p $word -o pid,user,%cpu,%mem,command 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|killall):argument-rest' fzf-flags '--preview-window=down:3:wrap'

# Env var value preview
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'

zstyle ':completion:*:*:rustup:*' ignored-patterns '+*'
zstyle ':completion:*:*:rustup:*' list-colors 'no=0:fi=0:*.rs=35:*.toml=36:*.md=32'

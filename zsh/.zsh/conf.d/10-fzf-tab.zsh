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

zstyle ':completion:*:*:rustup:*' ignored-patterns '+*'
zstyle ':completion:*:*:rustup:*' list-colors 'no=0:fi=0:*.rs=35:*.toml=36:*.md=32'

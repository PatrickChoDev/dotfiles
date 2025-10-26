HISTORY_SUBSTRING_SEARCH_PREFIXED=1

source "$ZSH_HOME/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^R' fzf-history-widget

# === Ctrl+R scoped to current input (e.g., 'docker') ===
fzf-history-widget() {
  local query="${BUFFER}"
  [[ -z "$query" ]] && query="."
  BUFFER=$(fc -rl 1 | grep -i "$query" | fzf \
    --tac \
    --no-sort \
    --height 40% \
    --layout=reverse \
    --prompt='history> ' \
    --query="$query" \
    --ansi) || return
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N fzf-history-widget


HISTORY_SUBSTRING_SEARCH_PREFIXED=1

source "$ZSH_HOME/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"

fzf-history-widget() {
  local query="${BUFFER}"
  fc -R
  local selected
  selected=$(fc -rl 1 \
    | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//' \
    | sed 's/\\n.*//' \
    | awk 'length($0) <= 200 && !seen[$0]++' \
    | fzf \
      --no-sort \
      --scheme=history \
      --height 40% \
      --layout=reverse \
      --prompt='history> ' \
      --query="$query" \
      --ansi)
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
  fi
  zle reset-prompt
}

for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" '^[[A' history-substring-search-up
  bindkey -M "$keymap" '^[[B' history-substring-search-down
done

if (( $+commands[fzf] )); then
  zle -N fzf-history-widget
  for keymap in emacs viins vicmd; do
    bindkey -M "$keymap" '^R' fzf-history-widget
  done
fi

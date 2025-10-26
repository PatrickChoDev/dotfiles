_autosuggest_bgload() {  
  source "$ZSH_HOME/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
}

_autosuggest_hook() {
  zle -D zle-line-init
  _autosuggest_bgload &!
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-init _autosuggest_hook
zle -N zle-line-init _autosuggest_hook

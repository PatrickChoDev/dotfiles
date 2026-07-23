# Powerlevel10k prompt.
[[ -r "$HOME/.zsh/.p10k.zsh" ]] && source "$HOME/.zsh/.p10k.zsh"
source "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"

_p10k_apply_prompt_char() {
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=5
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
}

_p10k_apply_prompt_char
(( ! $+functions[p10k] )) || p10k reload

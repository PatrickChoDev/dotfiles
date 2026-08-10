# Powerlevel10k prompt.
[[ -r "$HOME/.zsh/.p10k.zsh" ]] && source "$HOME/.zsh/.p10k.zsh"
source "$HOME/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"

_p10k_apply_prompt_char() {
  # Insert mode = green (red if last command failed), normal/visual/replace mode = yellow.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VICMD,VIVIS,VIOWR}_FOREGROUND=3
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VICMD,VIVIS,VIOWR}_FOREGROUND=3

  # Show the previous command's exit code when it failed.
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
  local idx=${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(i)prompt_char]}
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[1,idx-1]}
    status
    ${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[idx,-1]}
  )
}

_p10k_apply_prompt_char
(( ! $+functions[p10k] )) || p10k reload

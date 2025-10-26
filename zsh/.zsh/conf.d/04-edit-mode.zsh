# === Load mode preference from file ===
ZSH_MODE_FILE="${ZSH_HOME}/.zsh_mode"
[[ -f $ZSH_MODE_FILE ]] || echo vi > "$ZSH_MODE_FILE"
ZSH_EDIT_MODE=$(<"$ZSH_MODE_FILE")

# === Emacs Mode Setup ===
emacs_mode_setup() {
  bindkey -e
  bindkey "^A" beginning-of-line
  bindkey "^E" end-of-line
  bindkey "^K" kill-line
  bindkey "^U" backward-kill-line
  bindkey "^W" backward-kill-word
  echo emacs > "$ZSH_MODE_FILE"
  zle -N toggle_zsh_edit_mode
  bindkey '^G' toggle_zsh_edit_mode
  bindkey '^[[3~' delete-char
  bindkey '^[[3;3~' kill-word # alt + delete
  export ZSH_EDIT_MODE=emacs
}

# === Vim Mode Setup ===
vim_mode_setup() {
  bindkey -v
  bindkey -M viins "^A" beginning-of-line
  bindkey -M viins "^E" end-of-line
  bindkey -M viins "^K" kill-line
  bindkey -M viins "^U" backward-kill-line
  bindkey -M viins "^W" backward-kill-word
  bindkey -M viins "^[^?" backward-kill-word     # ⌥+⌫
  bindkey -M viins "^?" backward-delete-char     # Backspace
  bindkey -M viins "^H" backward-delete-char     # Some terminals
  zle -N toggle_zsh_edit_mode
  bindkey '^G' toggle_zsh_edit_mode
  bindkey '^[[3~' delete-char
  bindkey '^[[3;3~' kill-word # alt + delete
  echo vi > "$ZSH_MODE_FILE"
  export ZSH_EDIT_MODE=vi
}

# === Toggle with Ctrl+G ===
toggle_zsh_edit_mode() {
    if [[ $ZSH_EDIT_MODE == vi ]]; then
        emacs_mode_setup
        local mode_msg="[EMACS MODE]"
      else
        vim_mode_setup
        local mode_msg="[VI MODE]"
      fi
}
zle -N toggle_zsh_edit_mode

bindkey '^G' toggle_zsh_edit_mode  # Ctrl+G toggles mode
bindkey '^[[3~' delete-char
bindkey '^[[3;3~' kill-word # alt + delete

# === Start with saved mode ===
[[ $ZSH_EDIT_MODE == vi ]] && vim_mode_setup || emacs_mode_setup


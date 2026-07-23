# Vi keybindings, with sane emacs-style editing shortcuts kept in insert mode.
bindkey -v
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^[^?' backward-kill-word   # option+backspace
bindkey -M viins '^?' backward-delete-char   # backspace
bindkey -M viins '^H' backward-delete-char   # some terminals
bindkey '^[[3~' delete-char
bindkey '^[[3;3~' kill-word                  # option+delete

# option+left / option+right word jumps (Ghostty sends CSI with a modifier)
bindkey -M viins '^[[1;3D' backward-word     # option+left
bindkey -M viins '^[[1;3C' forward-word      # option+right
bindkey -M viins '^[b' backward-word         # fallback: alt-as-meta
bindkey -M viins '^[f' forward-word          # fallback: alt-as-meta

# Switch the terminal cursor shape with vi mode so it's visible alongside p10k's prompt char.
function zle-keymap-select {
  case $KEYMAP in
    vicmd) print -n '\e[1 q' ;;   # block cursor = normal mode
    *)     print -n '\e[5 q' ;;   # beam cursor = insert mode
  esac
}
zle -N zle-keymap-select

function zle-line-init {
  print -n '\e[5 q'
}
zle -N zle-line-init

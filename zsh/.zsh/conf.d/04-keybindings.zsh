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

# Cursor is always block; mode is conveyed by p10k's prompt char color instead.
function zle-keymap-select { print -n '\e[1 q' }
zle -N zle-keymap-select

function zle-line-init { print -n '\e[1 q' }
zle -N zle-line-init

# Toggle vi-mode on/off entirely (Ctrl+G, also reachable as Cmd+G via Ghostty).
function toggle-vi-mode {
  if [[ -o vi ]]; then
    bindkey -e
    zle -K emacs
  else
    bindkey -v
    zle -K viins
  fi
  zle -R
}
zle -N toggle-vi-mode
bindkey -M viins '^G' toggle-vi-mode
bindkey -M vicmd '^G' toggle-vi-mode
bindkey -M emacs '^G' toggle-vi-mode

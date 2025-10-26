# === Completion Definitions ===
source "$ZSH_HOME/plugins/zsh-completions/zsh-completions.plugin.zsh"

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH_HOME/.zcompcache"


# Relax and more fuzzy match
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

# === Enable Completion System ===
autoload -Uz compinit

ZCOMPDUMP="${ZSH_HOME}/.zcompdump"
ZCOMPDUMP_TRACKER="${ZCOMPDUMP}.timestamp"

# Get current completion sources hash (e.g., from $fpath)
_zcompinit_fingerprint() {
  (
    for dir in $fpath; do
      [[ -d "$dir" ]] && find "$dir" -type f -print0
    done | xargs -0 stat -f '%m' 2>/dev/null
  ) | sort | md5
}

# If cache missing, or fingerprint changed → reload compinit
if [[ ! -f "$ZCOMPDUMP_TRACKER" ]] || \
   [[ "$(_zcompinit_fingerprint)" != "$(cat "$ZCOMPDUMP_TRACKER" 2>/dev/null)" ]]; then
  compinit -i -d "$ZCOMPDUMP"
  _zcompinit_fingerprint > "$ZCOMPDUMP_TRACKER"
else
  compinit -C -d "$ZCOMPDUMP"
fi


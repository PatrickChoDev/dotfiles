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

_zcompdump_needs_update() {
  [[ ! -f "$ZCOMPDUMP" ]] && return 0
  # Regenerate if older than 20 hours
  zmodload zsh/stat
  local -A _zstat
  zstat -H _zstat "$ZCOMPDUMP"
  local -i age=$(( EPOCHSECONDS - _zstat[mtime] ))
  (( age > 72000 )) && return 0
  # Regenerate if fpath element count changed (new completions installed)
  local count_file="${ZCOMPDUMP}.fpathcount"
  local cur_count=${#fpath[@]}
  [[ "$(cat $count_file 2>/dev/null)" != "$cur_count" ]] && { echo $cur_count > $count_file; return 0 }
  return 1
}

if _zcompdump_needs_update; then
  compinit -i -d "$ZCOMPDUMP"
else
  compinit -C -d "$ZCOMPDUMP"
fi

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' squeeze-slashes true


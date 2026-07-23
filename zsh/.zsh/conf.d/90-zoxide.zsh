export _ZO_ECHO=1
export _ZO_EXCLUDE_DIRS="$HOME/Library:${TMPDIR:-/tmp}:/private/tmp:/var/folders"
export _ZO_FZF_OPTS="--height=40% --reverse --preview='lsd --color=always {2..} 2>/dev/null || ls {2..}' --preview-window=right:40%"

if (( $+commands[zoxide] )); then
  _ZOXIDE_INIT_CACHE="$HOME/.cache/zsh/zoxide_init.zsh"

  if [[ ! -s "$_ZOXIDE_INIT_CACHE" ]]; then
    mkdir -p "${_ZOXIDE_INIT_CACHE:h}"
    _zoxide_init_tmp="${_ZOXIDE_INIT_CACHE}.tmp.$$"
    if zoxide init zsh > "$_zoxide_init_tmp"; then
      mv "$_zoxide_init_tmp" "$_ZOXIDE_INIT_CACHE"
    else
      rm -f "$_zoxide_init_tmp"
    fi
  fi

  [[ -s "$_ZOXIDE_INIT_CACHE" ]] && source "$_ZOXIDE_INIT_CACHE"

  _zoxide_project_fallback() {
    local query="$1"
    local dir

    [[ "$#" -eq 1 && -n "$query" && "$query" != -* ]] || return 1

    for dir in \
      "$HOME/$query" \
      "$HOME/Developer/$query" \
      "$HOME/Developer"/*/"$query"(N) \
      "$HOME/Code/$query" \
      "$HOME/Projects/$query" \
      "$HOME/src/$query"
    do
      if [[ -d "$dir" ]]; then
        __zoxide_cd "$dir"
        return
      fi
    done

    return 1
  }

  z() {
    __zoxide_doctor

    if [[ "$#" -eq 0 ]]; then
      __zoxide_cd ~
    elif [[ "$#" -eq 1 && "$1" == '-' ]]; then
      __zoxide_cd "$OLDPWD"
    elif [[ "$#" -eq 1 ]] && { [[ "$1" =~ ^[-+][0-9]+$ ]] || (builtin cd -q -- "$1") &>/dev/null; }; then
      __zoxide_cd "$1"
    elif [[ "$#" -eq 2 && "$1" == '--' ]]; then
      __zoxide_cd "$2"
    else
      local result
      if result="$(command zoxide query --exclude "$(__zoxide_pwd)" -- "$@" 2>/dev/null)"; then
        __zoxide_cd "$result"
      elif _zoxide_project_fallback "$@"; then
        command zoxide add -- "$PWD" 2>/dev/null || :
      else
        echo "zoxide: no match found" >&2
        return 1
      fi
    fi
  }
fi

zoxide-reset-cache() {
  if (( $+commands[zoxide] )); then
    local tmp="${_ZOXIDE_INIT_CACHE}.tmp.$$"
    if zoxide init zsh > "$tmp"; then
      mv "$tmp" "$_ZOXIDE_INIT_CACHE"
      source "$_ZOXIDE_INIT_CACHE"
      echo "zoxide init cache regenerated"
    else
      rm -f "$tmp"
      echo "zoxide: failed to regenerate init cache" >&2
      return 1
    fi
  else
    echo "zoxide: command not found" >&2
    return 1
  fi
}

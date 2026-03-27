export _ZO_ECHO=1
export _ZO_EXCLUDE_DIRS="$HOME/Library:${TMPDIR:-/tmp}:/private/tmp:/var/folders"
export _ZO_FZF_OPTS="--height=40% --reverse --preview='lsd --color=always {2..} 2>/dev/null || ls {2..}' --preview-window=right:40%"

_ZOXIDE_INIT_CACHE="$HOME/.cache/zsh/zoxide_init.zsh"
if [[ ! -f "$_ZOXIDE_INIT_CACHE" ]]; then
  mkdir -p "${_ZOXIDE_INIT_CACHE:h}"
  zoxide init zsh > "$_ZOXIDE_INIT_CACHE"
fi
source "$_ZOXIDE_INIT_CACHE"

zoxide-reset-cache() {
  zoxide init zsh > "$_ZOXIDE_INIT_CACHE"
  echo "zoxide init cache regenerated"
}


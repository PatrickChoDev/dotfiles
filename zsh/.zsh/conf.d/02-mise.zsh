export MISE_POETRY_VENV_AUTO=1

if (( $+commands[mise] )); then
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec mise_lazy_init
fi

mise_lazy_init() {
  eval "$(mise activate zsh)"
  add-zsh-hook -d preexec mise_lazy_init
}

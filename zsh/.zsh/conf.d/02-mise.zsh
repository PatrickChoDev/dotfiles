export MISE_POETRY_VENV_AUTO=1

autoload -Uz add-zsh-hook
add-zsh-hook preexec mise_lazy_init

mise_lazy_init() {
  eval "$(mise activate zsh)"
  add-zsh-hook -d preexec mise_lazy_init
}

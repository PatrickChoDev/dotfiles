# === Base ENV ===
export ZSH_HOME="$HOME/.zsh"

# === Locale ===
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# === Editor ===
export EDITOR="vim"

# Enable colored output for tools
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

path=(
  $HOME/Library/Application\ Support/Jetbrains/Toolbox/scripts
  $HOME/.local/share/mise/shims
  $HOME/.cargo/bin
  $path
)

fpath=(
  $ZSH_HOME/completions
  $fpath
)


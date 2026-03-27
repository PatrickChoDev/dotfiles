# === Base ENV ===
export ZSH_HOME="$HOME/.zsh"

# === OS Detection ===
[[ "$OSTYPE" == darwin* ]] && IS_MACOS=1 || IS_MACOS=0

# === Locale ===
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# === Editor ===
export EDITOR="vim"

# Enable colored output for tools
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

path=(
  $HOME/.local/bin
  $HOME/.local/share/mise/shims
  $HOME/.cargo/bin
  $path
)

if (( IS_MACOS )); then
  path=(
    "$HOME/Library/Application Support/Jetbrains/Toolbox/scripts"
    /opt/homebrew/opt/coreutils/libexec/gnubin
    $path
  )
fi

fpath=(
  $ZSH_HOME/completions
  $fpath
)


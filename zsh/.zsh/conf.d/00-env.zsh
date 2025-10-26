export HOMEBREW_NO_ENV_HINTS=1



# HELPER FUNCTION
remove-zsh-hook() {
  local hook=$1 func=$2
  typeset -ga "${hook}s"
  eval "${hook}s=( \${${hook}s:#$func} )"
}

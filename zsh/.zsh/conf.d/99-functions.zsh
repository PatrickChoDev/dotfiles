source "$ZSH_HOME/functions/finder"

zsh-time() {
  for i in $(seq 1 5); do
    /usr/bin/time zsh -i -c exit 2>&1
  done
}

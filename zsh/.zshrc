#zmodload zsh/zprof

# if [ -n "$TMUX" ]; then
#   export DISABLE_AUTO_TITLE="true"
# fi

# Source everything in conf.d in order
for f in ~/.zsh/conf.d/*.zsh(N); do
  source "$f"
done


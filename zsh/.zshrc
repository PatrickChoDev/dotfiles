zmodload zsh/zprof
# Source everything in conf.d in order
for f in ~/.zsh/conf.d/*.zsh(N); do
  source "$f"
done


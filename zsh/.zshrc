# zmodload zsh/zprof

# Source early machine-local environment knobs before conf.d loads.
for f in ~/.zsh/local/env.zsh(N) ~/.zsh/local/pre/*.zsh(N); do
  source "$f"
done

# Source everything in conf.d in order
for f in ~/.zsh/conf.d/*.zsh(N); do
  source "$f"
done

# Source machine-local overrides, if present.
for f in ~/.zsh/local/*.zsh(N); do
  [[ "$f" == */env.zsh ]] && continue
  source "$f"
done

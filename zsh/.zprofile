export WORDCHARS='~!#$%^&*(){}[]<>?.+;-'

# macOS-only env
if (( IS_MACOS )); then
  export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources
fi

# Homebrew — works on macOS (/opt/homebrew) and Linux (/home/linuxbrew)
_brew_bin=""
[[ -x /opt/homebrew/bin/brew ]] && _brew_bin=/opt/homebrew/bin/brew
[[ -z "$_brew_bin" && -x /home/linuxbrew/.linuxbrew/bin/brew ]] && _brew_bin=/home/linuxbrew/.linuxbrew/bin/brew

if [[ -n "$_brew_bin" ]]; then
  _BREW_SHELLENV_CACHE="$HOME/.cache/zsh/brew_shellenv.zsh"
  if [[ ! -f "$_BREW_SHELLENV_CACHE" || "$_brew_bin" -nt "$_BREW_SHELLENV_CACHE" ]]; then
    mkdir -p "${_BREW_SHELLENV_CACHE:h}"
    "$_brew_bin" shellenv > "$_BREW_SHELLENV_CACHE"
  fi
  source "$_BREW_SHELLENV_CACHE"
fi
unset _brew_bin

eval "$(mise activate zsh --shims)"

# macOS-only integrations
if (( IS_MACOS )); then
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# pnpm
export PNPM_HOME="/Users/patrick/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

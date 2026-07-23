export WORDCHARS=''

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
  if [[ ! -s "$_BREW_SHELLENV_CACHE" || "$_brew_bin" -nt "$_BREW_SHELLENV_CACHE" ]]; then
    mkdir -p "${_BREW_SHELLENV_CACHE:h}"
    _brew_shellenv_tmp="${_BREW_SHELLENV_CACHE}.tmp.$$"
    if "$_brew_bin" shellenv > "$_brew_shellenv_tmp"; then
      mv "$_brew_shellenv_tmp" "$_BREW_SHELLENV_CACHE"
    else
      rm -f "$_brew_shellenv_tmp"
    fi
  fi
  [[ -s "$_BREW_SHELLENV_CACHE" ]] && source "$_BREW_SHELLENV_CACHE"
fi
unset _brew_bin _brew_shellenv_tmp

if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi

# macOS-only integrations
if (( IS_MACOS )); then
  [[ -r ~/.orbstack/shell/init.zsh ]] && source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
if [[ -d "$PNPM_HOME" ]]; then
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi
# pnpm end

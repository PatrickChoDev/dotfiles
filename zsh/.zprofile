export WORDCHARS='~!#$%^&*(){}[]<>?.+;-'
export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh --shims)"
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

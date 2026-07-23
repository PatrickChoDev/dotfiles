#!/usr/bin/env bash
set -e
PROGRAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$(dirname "$PROGRAM_DIR")/lib/common.sh"

install_macos_dependencies() {
  [ "$(uname -s)" = "Darwin" ] || return 0

  local brew_bin=""
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  elif [ -x /opt/homebrew/bin/brew ]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [ -x /usr/local/bin/brew ]; then
    brew_bin=/usr/local/bin/brew
  else
    print_warning "Homebrew not found; skipping zsh dependency installation"
    return 0
  fi

  local dependencies=(fzf lsd mise zoxide)
  local missing=()
  local dependency
  for dependency in "${dependencies[@]}"; do
    if ! "$brew_bin" list --formula "$dependency" >/dev/null 2>&1; then
      missing+=("$dependency")
    fi
  done

  if [ ${#missing[@]} -eq 0 ]; then
    print_info "Zsh dependencies already installed"
    return 0
  fi

  print_info "Installing missing zsh dependencies: ${missing[*]}"
  if ! "$brew_bin" install "${missing[@]}"; then
    print_warning "Some zsh dependencies could not be installed"
  fi
}

install_macos_dependencies
install_module "$PROGRAM_DIR"

#!/usr/bin/env bash
# Description: Zsh shell configuration
# Installs: ~/.zshrc, ~/.zshenv, ~/.zprofile, ~/.zsh/

set -e

# Get the directory where this script is located
ZSH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$ZSH_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Zsh configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$ZSH_DIR"

# Create symlinks for zsh
if [ -f "$ZSH_DIR/.zshrc" ]; then
    create_symlink "$ZSH_DIR/.zshrc" "$HOME/.zshrc"
fi

if [ -f "$ZSH_DIR/.zshenv" ]; then
    create_symlink "$ZSH_DIR/.zshenv" "$HOME/.zshenv"
fi

if [ -f "$ZSH_DIR/.zprofile" ]; then
    create_symlink "$ZSH_DIR/.zprofile" "$HOME/.zprofile"
fi

if [ -d "$ZSH_DIR/.zsh" ]; then
    create_symlink "$ZSH_DIR/.zsh" "$HOME/.zsh"
fi

print_success "Zsh installation completed!"

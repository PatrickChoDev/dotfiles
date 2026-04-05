#!/usr/bin/env bash
# Description: starship prompt
# Installs: ~/.config/starship.toml

set -e

# Get the directory where this script is located
STARSHIP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$STARSHIP_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Zsh configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$STARSHIP_DIR"

# Create symlinks for tmux
if [ -f "$STARSHIP_DIR/starship.toml" ]; then
    create_symlink "$STARSHIP_DIR/starship.toml" "$HOME/.config/starship.toml"
fi

print_success "tmux installation completed!"

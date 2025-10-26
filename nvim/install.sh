#!/usr/bin/env bash
# Description: Neovim text editor configuration
# Installs: ~/.config/nvim/

set -e

# Get the directory where this script is located
NVIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$NVIM_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Neovim configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$NVIM_DIR"

# Create symlink for nvim config directory
create_symlink "$NVIM_DIR" "$HOME/.config/nvim"

print_success "Neovim installation completed!"

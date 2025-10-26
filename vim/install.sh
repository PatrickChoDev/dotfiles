#!/usr/bin/env bash
# Description: Vim text editor configuration
# Installs: ~/.vimrc, ~/.vim/

set -e

# Get the directory where this script is located
VIM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$VIM_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Vim configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$VIM_DIR"

# Create symlinks for vim
create_symlink "$VIM_DIR/.vimrc" "$HOME/.vimrc"
create_symlink "$VIM_DIR/.vim" "$HOME/.vim"

print_success "Vim installation completed!"

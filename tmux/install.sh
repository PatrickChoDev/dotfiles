#!/usr/bin/env bash
# Description: tmux configuration
# Installs: ~/.tmux.conf ~/.tmux/plugins

set -e

# Get the directory where this script is located
TMUX_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$TMUX_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Zsh configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$TMUX_DIR"

# Create symlinks for tmux
if [ -f "$TMUX_DIR/tmux.conf" ]; then
    create_symlink "$TMUX_DIR/tmux.conf" "$HOME/.tmux.conf"
fi

if [ -d "$TMUX_DIR/plugins" ]; then
    create_symlink "$TMUX_DIR/plugins" "$HOME/.tmux/plugins"
fi

print_success "tmux installation completed!"

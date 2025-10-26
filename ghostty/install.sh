#!/usr/bin/env bash
# Description: Ghostty terminal emulator configuration
# Installs: ~/.config/ghostty/config, ~/.config/ghostty/themes/

set -e

# Get the directory where this script is located
GHOSTTY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$GHOSTTY_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Ghostty configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$GHOSTTY_DIR"

# Create symlink for ghostty config file
create_symlink "$GHOSTTY_DIR/config" "$HOME/.config/ghostty/config"

# Optionally link themes directory if you want to manage themes
if [ -d "$GHOSTTY_DIR/themes" ]; then
    create_symlink "$GHOSTTY_DIR/themes" "$HOME/.config/ghostty/themes"
fi

print_success "Ghostty installation completed!"

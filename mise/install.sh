#!/usr/bin/env bash
# Description: Mise-en-place devtools
# Installs: ~/.config/mise/config.toml

set -e

# Get the directory where this script is located
MISE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the dotfiles root directory (parent of this script's directory)
DOTFILES_DIR="$(dirname "$MISE_DIR")"

# Source common functions
if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing Mise-en-place configuration..."

# Initialize git submodules if ext/ directory exists
init_submodules "$MISE_DIR"

# Create symlink for ghostty config file
create_symlink "$MISE_DIR/config.toml" "$HOME/.config/mise/config.toml"

print_success "Mise-en-place installation completed!"

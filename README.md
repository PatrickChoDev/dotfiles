# Dotfiles

Personal configuration files for vim, neovim, ghostty, and zsh.

## Quick Start

```bash
# Clone with submodules
git clone --recursive https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# List available programs and their status
./install.sh --list

# Install everything
./install.sh

# Or install specific program
./install.sh vim
./install.sh nvim
./install.sh ghostty
./install.sh zsh
```

## What It Does

- Creates symlinks from your home directory to this repository
- Automatically initializes git submodules (plugins/themes)
- Detects conflicts and creates timestamped backups
- All backups in one session share the same timestamp

## Status Indicators

- **✓ installed** - Already correctly linked
- **⚠ conflict** - File exists but not linked correctly
- **○ not installed** - Ready to install

## Features

- ✅ Automatic git submodule initialization
- ✅ Conflict detection with backup creation
- ✅ Shared backup timestamp per session
- ✅ Individual or bulk installation
- ✅ Idempotent (safe to run multiple times)

## Adding New Programs

1. Create directory: `mkdir dotfiles/newprogram`
2. Add install script:

```bash
#!/usr/bin/env bash
# Description: Your program description
# Installs: ~/.config/newprogram/config

set -e

PROGRAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$PROGRAM_DIR")"

if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
    source "$DOTFILES_DIR/lib/common.sh"
else
    echo "Error: Cannot find common.sh library"
    exit 1
fi

print_info "Installing newprogram..."
init_submodules "$PROGRAM_DIR"
create_symlink "$PROGRAM_DIR/config" "$HOME/.config/newprogram/config"
print_success "Newprogram installation completed!"
```

3. Make executable: `chmod +x dotfiles/newprogram/install.sh`
4. Add to `PROGRAMS` array in `install.sh`

## Git Submodules

Plugins and themes are managed as git submodules. The install scripts automatically clone them if missing.

### Update Submodules

```bash
git submodule update --remote
```

### Add New Submodule

```bash
git submodule add <repository-url> <program>/ext/<name>
```

## License

MIT
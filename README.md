# Dotfiles

My personal dotfiles for vim, neovim, and ghostty.

## Installation

### Quick Start

List available programs and their status:
```bash
./install.sh --list
```

Install all dotfiles:
```bash
./install.sh
```

Install a specific program:
```bash
./install.sh vim      # Install only vim
./install.sh nvim     # Install only neovim
./install.sh ghostty  # Install only ghostty
```

### What it does

The install script will:
1. Create symlinks from your home directory to the files in this repository
2. **Automatically** initialize git submodules (plugins in `ext/` directories) if not already cloned
3. Detect any existing files/directories that would conflict
4. Ask for confirmation before backing up and replacing conflicting files
5. Create backup files with timestamps (e.g., `.vimrc.backup.20240115_143022`)

### Checking Status

Before installing, you can check what's available and the current status:

```bash
./install.sh --list
```

This shows:
- **✓ installed** - Already correctly linked
- **⚠ conflict** - File exists but not linked correctly
- **○ not installed** - Ready to install

### Conflict Handling

If a file already exists at the target location, the script will:
- Check if it's already a symlink pointing to the dotfiles (skip if yes)
- Prompt you to backup and replace the existing file
- Create a timestamped backup if you choose to replace
- Skip the file if you choose not to replace

## Structure

```
dotfiles/
├── install.sh           # Main installation script
├── lib/
│   └── common.sh       # Shared functions and utilities
├── vim/
│   ├── install.sh       # Vim-specific installer
│   ├── .vimrc          # Vim configuration
│   └── .vim/           # Vim runtime files
├── nvim/
│   ├── install.sh       # Neovim-specific installer
│   ├── init.lua        # Neovim configuration
│   └── lua/            # Lua modules
└── ghostty/
    ├── install.sh       # Ghostty-specific installer
    ├── config          # Ghostty configuration
    └── themes/         # Ghostty themes
```

## Installed Symlinks

### Vim
- `~/.vimrc` → `dotfiles/vim/.vimrc`
- `~/.vim` → `dotfiles/vim/.vim`

### Neovim
- `~/.config/nvim` → `dotfiles/nvim`

### Ghostty
- `~/.config/ghostty/config` → `dotfiles/ghostty/config`
- `~/.config/ghostty/themes` → `dotfiles/ghostty/themes`

## Adding New Programs

To add a new program to the dotfiles:

1. Create a new directory for the program:
   ```bash
   mkdir dotfiles/newprogram
   ```

2. Create an `install.sh` script in that directory:
   ```bash
   #!/usr/bin/env bash
   # Description: Your program description here
   # Installs: ~/.config/newprogram/config
   
   set -e
   
   # Get the directory where this script is located
   PROGRAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   
   # Get the dotfiles root directory (parent of this script's directory)
   DOTFILES_DIR="$(dirname "$PROGRAM_DIR")"
   
   # Source common functions
   if [ -f "$DOTFILES_DIR/lib/common.sh" ]; then
       source "$DOTFILES_DIR/lib/common.sh"
   else
       echo "Error: Cannot find common.sh library"
       exit 1
   fi
   
   print_info "Installing newprogram..."
   
   # Create your symlinks
   create_symlink "$PROGRAM_DIR/config" "$HOME/.config/newprogram/config"
   
   print_success "Newprogram installation completed!"
```

3. Make it executable:
   ```bash
   chmod +x dotfiles/newprogram/install.sh
   ```

4. Add the program to the `PROGRAMS` array in the main `install.sh`:
   ```bash
   PROGRAMS=("vim" "nvim" "ghostty" "newprogram")
   ```

## Uninstalling

To uninstall, simply remove the symlinks:
```bash
# Remove all symlinks manually
rm ~/.vimrc
rm ~/.vim
rm -r ~/.config/nvim
rm ~/.config/ghostty/config
rm ~/.config/ghostty/themes
```

Then restore from backups if needed:
```bash
# Example: restore vim config
mv ~/.vimrc.backup.20240115_143022 ~/.vimrc
```

## Features

- ✅ Status checking with `--list` command
- ✅ Conflict detection and resolution
- ✅ Automatic timestamped backups
- ✅ Individual or bulk installation
- ✅ Colored output for better readability
- ✅ Standalone program installers (can run independently)
- ✅ Idempotent (safe to run multiple times)
- ✅ Shared library (`lib/common.sh`) for DRY code
- ✅ Easy to extend with new programs
- ✅ Description metadata in install scripts
- ✅ **Automatic git submodule initialization** - plugins/themes in `ext/` are auto-cloned if missing

## Requirements

- Bash 4.0+
- Standard Unix utilities (ln, mv, mkdir, date)

## License

MIT

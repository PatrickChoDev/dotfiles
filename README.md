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

## Machine-Local Overrides

Keep shared defaults on the main branch and put machine-specific patches in ignored
local override files. Use branches for experiments, not long-lived per-machine
configuration.

Supported local hooks:

- `zsh/.zsh/local/env.zsh` or `zsh/.zsh/local/pre/*.zsh` for early env knobs
- `zsh/.zsh/local/*.zsh` for machine-local zsh settings
- `nvim/local.lua` for machine-local Neovim settings
- `tmux/local.conf` or `~/.tmux/local.conf` for machine-local tmux settings
- `ghostty/local` or `~/.config/ghostty/local` for machine-local Ghostty settings

Examples:

```bash
mkdir -p zsh/.zsh/local
printf 'export WORKSPACE="$HOME/Developer"\n' > zsh/.zsh/local/10-paths.zsh
printf 'typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2\n' > zsh/.zsh/local/env.zsh

cat > nvim/local.lua <<'EOF'
vim.opt.colorcolumn = '100'
EOF

mkdir -p ~/.tmux
printf 'set -g status-interval 1\n' > tmux/local.conf

mkdir -p ~/.config/ghostty
printf 'font-size = 14\n' > ghostty/local
```

If you create `tmux/local.conf` or `ghostty/local` after installing, rerun the
matching installer so the optional local file is linked into place.

### Zsh Prompt

The zsh prompt uses Powerlevel10k from `zsh/.zsh/plugins/powerlevel10k` with a
small config at `zsh/.zsh/.p10k.zsh`. It starts from P10k's bundled Pure preset
and uses the custom arrow for success and custom cross for failed commands.

- `POWERLEVEL9K_PROMPT_CHAR_OK_*_CONTENT_EXPANSION=''` controls the success symbol
- `POWERLEVEL9K_PROMPT_CHAR_ERROR_*_CONTENT_EXPANSION=''` controls the failed-command symbol
- `POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2` controls when command duration is shown

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

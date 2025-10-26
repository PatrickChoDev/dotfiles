#!/usr/bin/env bash

# Common functions and variables for dotfiles installation
# This file should be sourced by install scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Ask user for confirmation
ask_confirmation() {
    local prompt="$1"
    local response

    while true; do
        read -p "$(echo -e ${YELLOW}[?]${NC} $prompt [y/n]: )" response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Check if a path exists and handle conflicts
handle_conflict() {
    local target="$1"
    local source="$2"

    if [ -e "$target" ] || [ -L "$target" ]; then
        # Check if it's already a symlink pointing to our source
        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
            print_info "Already linked: $target -> $source"
            return 0
        fi

        print_warning "Conflict detected: $target already exists"

        if ask_confirmation "Do you want to backup and replace it?"; then
            local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$target" "$backup"
            print_success "Backed up to: $backup"
            return 0
        else
            print_info "Skipping: $target"
            return 1
        fi
    fi

    return 0
}

# Create a symlink with conflict handling
create_symlink() {
    local source="$1"
    local target="$2"

    if ! handle_conflict "$target" "$source"; then
        return 1
    fi

    # Create parent directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        print_info "Created directory: $target_dir"
    fi

    ln -sf "$source" "$target"
    print_success "Linked: $target -> $source"
    return 0
}

# Check if directory is a git repository
is_git_repo() {
    local dir="$1"
    if [ -d "$dir/.git" ] || git -C "$dir" rev-parse --git-dir > /dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Initialize git submodules in program directory
init_submodules() {
    local program_dir="$1"

    # Check if we're in a git repository
    if ! is_git_repo "$DOTFILES_DIR"; then
        return 0
    fi

    # Check if .gitmodules exists
    if [ ! -f "$DOTFILES_DIR/.gitmodules" ]; then
        return 0
    fi

    # Get the relative path from DOTFILES_DIR to program_dir
    local rel_path="${program_dir#$DOTFILES_DIR/}"

    # Check if there are submodules for this program (with or without trailing slash)
    if grep -q "path = $rel_path" "$DOTFILES_DIR/.gitmodules" 2>/dev/null; then
        print_info "Checking git submodules for $rel_path..."

        # Check if submodules are initialized (check if ext/ dirs are empty)
        local needs_init=false
        while IFS= read -r line; do
            if [[ "$line" =~ path\ =\ ($rel_path[^[:space:]]*) ]]; then
                local submod_path="${BASH_REMATCH[1]}"
                local full_path="$DOTFILES_DIR/$submod_path"

                # Check if submodule directory is empty or doesn't exist
                if [ ! -d "$full_path" ] || [ -z "$(ls -A "$full_path" 2>/dev/null)" ]; then
                    needs_init=true
                    break
                fi
            fi
        done < "$DOTFILES_DIR/.gitmodules"

        if [ "$needs_init" = true ]; then
            print_info "Initializing git submodules..."
            (cd "$DOTFILES_DIR" && git submodule update --init --recursive) > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                print_success "Git submodules initialized"
            else
                print_warning "Failed to initialize submodules (git may not be available)"
            fi
        else
            print_info "Git submodules already initialized"
        fi
    fi

    return 0
}

#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$DOTFILES_DIR/lib/common.sh"

# Export backup timestamp for all child scripts to use
export BACKUP_TIMESTAMP

# List of available programs
PROGRAMS=("vim" "nvim" "ghostty" "zsh" "mise")

# Extract description from install script header
get_program_description() {
    local install_script="$1"
    local description=""

    if [ ! -f "$install_script" ]; then
        echo "No install script found"
        return
    fi

    # Extract all Description lines
    while IFS= read -r line; do
        if [[ "$line" =~ ^#\ Description:\ (.+)$ ]]; then
            description="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^#\ Installs:\ (.+)$ ]]; then
            if [ -n "$description" ]; then
                description="$description"$'\n'"    Installs: ${BASH_REMATCH[1]}"
            fi
        elif [[ "$line" =~ ^[^#] ]]; then
            # Stop at first non-comment line
            break
        fi
    done <"$install_script"

    echo "$description"
}

# Check installation status for a program
check_install_status() {
    local program="$1"
    local program_dir="$DOTFILES_DIR/$program"

    # Define what each program installs
    case "$program" in
    vim)
        local targets=("$HOME/.vimrc" "$HOME/.vim")
        local sources=("$program_dir/.vimrc" "$program_dir/.vim")
        ;;
    nvim)
        local targets=("$HOME/.config/nvim")
        local sources=("$program_dir")
        ;;
    ghostty)
        local targets=("$HOME/.config/ghostty/config" "$HOME/.config/ghostty/themes")
        local sources=("$program_dir/config" "$program_dir/themes")
        ;;
    zsh)
        local targets=("$HOME/.zshrc" "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zsh")
        local sources=("$program_dir/.zshrc" "$program_dir/.zshenv" "$program_dir/.zprofile" "$program_dir/.zsh")
        ;;
    mise)
        local targets=("$HOME/.config/mise/config.toml")
        local sources=("$program_dir/config.toml")
        ;;
    *)
        echo "unknown"
        return
        ;;
    esac

    local installed=0
    local conflict=0
    local free=0

    for i in "${!targets[@]}"; do
        local target="${targets[$i]}"
        local source="${sources[$i]}"

        if [ -e "$target" ] || [ -L "$target" ]; then
            # Something exists at target
            if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
                # Correct symlink
                ((installed++))
            else
                # Conflict
                ((conflict++))
            fi
        else
            # Nothing exists
            ((free++))
        fi
    done

    # Determine overall status
    if [ $installed -gt 0 ] && [ $conflict -eq 0 ] && [ $free -eq 0 ]; then
        echo "installed"
    elif [ $conflict -gt 0 ]; then
        echo "conflict"
    else
        echo "not-installed"
    fi
}

# List all available programs with details
list_programs() {
    echo -e "${BLUE}Available programs:${NC}"
    echo ""

    for program in "${PROGRAMS[@]}"; do
        local program_dir="$DOTFILES_DIR/$program"
        local install_script="$program_dir/install.sh"

        if [ ! -d "$program_dir" ]; then
            echo -e "  ${RED}✗${NC} ${YELLOW}$program${NC} - directory not found"
            echo ""
            continue
        fi

        # Get description
        local description=$(get_program_description "$install_script")
        if [ -z "$description" ]; then
            description="No description available"
        fi

        # Get installation status
        local status=$(check_install_status "$program")
        local status_icon=""
        local status_text=""
        local status_color=""

        case "$status" in
        installed)
            status_icon="${GREEN}✓${NC}"
            status_text="${GREEN}installed${NC}"
            ;;
        conflict)
            status_icon="${YELLOW}⚠${NC}"
            status_text="${YELLOW}conflict${NC}"
            ;;
        not-installed)
            status_icon="${BLUE}○${NC}"
            status_text="${BLUE}not installed${NC}"
            ;;
        *)
            status_icon="${RED}?${NC}"
            status_text="${RED}unknown${NC}"
            ;;
        esac

        # Print program info
        echo -e "  $status_icon ${YELLOW}$program${NC} [$status_text]"

        # Print description (with proper indentation for multiline)
        while IFS= read -r desc_line; do
            echo -e "    $desc_line"
        done <<<"$description"

        echo ""
    done
}

# Install a specific program
install_program() {
    local program="$1"
    local program_dir="$DOTFILES_DIR/$program"

    if [ ! -d "$program_dir" ]; then
        print_error "Program '$program' not found in $DOTFILES_DIR"
        return 1
    fi

    print_info "Installing $program..."

    # Check if program has its own install script
    if [ -f "$program_dir/install.sh" ]; then
        print_info "Running custom install script for $program"
        (cd "$program_dir" && bash install.sh)
    else
        print_warning "No install.sh found for $program, skipping"
        return 1
    fi

    return 0
}

# Show usage information
show_usage() {
    cat <<EOF
Usage: $0 [COMMAND|PROGRAM]

Install dotfiles by creating symlinks to their respective locations.

Commands:
  --list, -l   Show available programs with status
  --help, -h   Show this help message

Arguments:
  PROGRAM      Optional. Specific program to install (${PROGRAMS[*]})
               If not provided, will install all programs.

Examples:
  $0           # Install all programs
  $0 --list    # List available programs with status
  $0 vim       # Install only vim
  $0 nvim      # Install only nvim

EOF
    list_programs
}

# Main installation logic
main() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     Dotfiles Installation Script      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""

    # Check for help flag
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        exit 0
    fi

    # Check for list command
    if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
        list_programs
        exit 0
    fi

    # If a specific program is provided
    if [ -n "$1" ]; then
        local program="$1"

        # Validate program name
        if [[ ! " ${PROGRAMS[@]} " =~ " ${program} " ]]; then
            print_error "Unknown program: $program"
            echo ""
            show_usage
            exit 1
        fi

        install_program "$program"
        exit_code=$?

        echo ""
        if [ $exit_code -eq 0 ]; then
            print_success "Installation of $program completed!"
        else
            print_error "Installation of $program failed!"
        fi

        exit $exit_code
    fi

    # Install all programs
    print_info "Installing all programs..."
    echo ""

    local failed_programs=()

    for program in "${PROGRAMS[@]}"; do
        if ! install_program "$program"; then
            failed_programs+=("$program")
        fi
        echo ""
    done

    # Summary
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          Installation Summary          ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"

    if [ ${#failed_programs[@]} -eq 0 ]; then
        print_success "All programs installed successfully!"
        exit 0
    else
        print_warning "Some programs failed to install:"
        for program in "${failed_programs[@]}"; do
            echo "  - $program"
        done
        exit 1
    fi
}

# Export variables so they can be used by program-specific install scripts
export DOTFILES_DIR

# Run main function
main "$@"

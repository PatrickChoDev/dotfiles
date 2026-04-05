#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$DOTFILES_DIR/lib/common.sh"

# Export so child install scripts inherit it
export DOTFILES_DIR
export BACKUP_TIMESTAMP

# Auto-discover programs: any subdirectory containing a links.sh
get_programs() {
    local programs=()
    for dir in "$DOTFILES_DIR"/*/; do
        if [ -f "${dir}links.sh" ]; then
            programs+=("$(basename "$dir")")
        fi
    done
    echo "${programs[@]}"
}

# Check installation status for a program by reading its links.sh
check_install_status() {
    local program="$1"
    local program_dir="$DOTFILES_DIR/$program"

    load_module_links "$program_dir" 2>/dev/null || { echo "unknown"; return; }

    local installed=0 conflict=0 free=0

    for entry in "${LINKS[@]}"; do
        local src target
        src="$(echo "${entry%% ->*}" | xargs)"
        target="$(echo "${entry##*-> }" | xargs)"

        local abs_src
        if [ "$src" = "." ]; then
            abs_src="$program_dir"
        else
            abs_src="$program_dir/$src"
        fi
        target="${target/#\~/$HOME}"

        # Skip entries whose source doesn't exist (optional links)
        [ -e "$abs_src" ] || continue

        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ -L "$target" ] && [ "$(readlink "$target")" = "$abs_src" ]; then
                ((installed++))
            else
                ((conflict++))
            fi
        else
            ((free++))
        fi
    done

    if [ $installed -gt 0 ] && [ $conflict -eq 0 ] && [ $free -eq 0 ]; then
        echo "installed"
    elif [ $conflict -gt 0 ]; then
        echo "conflict"
    else
        echo "not-installed"
    fi
}

# List all available programs with status
list_programs() {
    echo -e "${BLUE}Available programs:${NC}"
    echo ""

    local programs
    read -ra programs <<< "$(get_programs)"

    for program in "${programs[@]}"; do
        local program_dir="$DOTFILES_DIR/$program"

        load_module_links "$program_dir" 2>/dev/null || continue
        local description="${DESCRIPTION:-No description available}"

        local status
        status=$(check_install_status "$program")

        local status_icon status_text
        case "$status" in
        installed)
            status_icon="${GREEN}✓${NC}"; status_text="${GREEN}installed${NC}" ;;
        conflict)
            status_icon="${YELLOW}⚠${NC}"; status_text="${YELLOW}conflict${NC}" ;;
        not-installed)
            status_icon="${BLUE}○${NC}"; status_text="${BLUE}not installed${NC}" ;;
        *)
            status_icon="${RED}?${NC}"; status_text="${RED}unknown${NC}" ;;
        esac

        echo -e "  $status_icon ${YELLOW}$program${NC} [$status_text]"
        echo -e "    $description"
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

    if [ -f "$program_dir/install.sh" ]; then
        (cd "$program_dir" && bash install.sh)
    else
        print_warning "No install.sh found for $program, skipping"
        return 1
    fi
}

# Update all git submodules
update_deps() {
    if ! is_git_repo "$DOTFILES_DIR"; then
        print_error "Not a git repository: $DOTFILES_DIR"
        return 1
    fi

    print_info "Updating all git submodules..."
    (cd "$DOTFILES_DIR" && git submodule update --init --recursive --remote)
    print_success "All submodules updated!"
}

# Show usage information
show_usage() {
    local programs
    read -ra programs <<< "$(get_programs)"

    cat <<EOF
Usage: $0 [COMMAND|PROGRAM]

Install dotfiles by creating symlinks to their respective locations.

Commands:
  --list, -l        Show available programs with status
  --update-deps, -u Update all git submodules to latest
  --help, -h        Show this help message

Arguments:
  PROGRAM      Optional. Specific program to install (${programs[*]})
               If not provided, will install all programs.

Examples:
  $0           # Install all programs
  $0 --list    # List available programs with status
  $0 -u        # Update all submodule dependencies
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

    case "$1" in
    -h|--help) show_usage; exit 0 ;;
    -l|--list) list_programs; exit 0 ;;
    -u|--update-deps) update_deps; exit $? ;;
    esac

    local programs
    read -ra programs <<< "$(get_programs)"

    if [ -n "$1" ]; then
        local program="$1"
        local found=false
        for p in "${programs[@]}"; do
            [ "$p" = "$program" ] && found=true && break
        done

        if ! $found; then
            print_error "Unknown program: $program"
            echo ""
            show_usage
            exit 1
        fi

        install_program "$program"
        local exit_code=$?
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
    for program in "${programs[@]}"; do
        if ! install_program "$program"; then
            failed_programs+=("$program")
        fi
        echo ""
    done

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

main "$@"

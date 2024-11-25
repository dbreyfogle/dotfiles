#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=$(dirname "$(readlink -f "$0")")
CONFIG_FILE="$REPO_ROOT/config.yaml"
STATE_FILE="$REPO_ROOT/state.yaml"
REQUIRED_COMMANDS=(
    "curl"
    "git"
    "yq"
)
VALID_OS=(
    "fedora"
    "macos"
    "ubuntu"
)
OS=""
DISABLED=()
INSTALLED=()
APPS=()
INSTALL_QUEUE=()

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}
error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

usage() {
    cat << EOF
Usage: $(basename "$0") [options]

Options:
    -h, --help             Show this help message
    -o, --os STRING        Operating system (${VALID_OS[*]})
    -a, --apps STRING      Comma-separated list of apps to install (default: all)

Example:
    $(basename "$0") --os=fedora --apps=nvim,tmux,zsh
EOF
}

yq_helper() {
    local path=$1
    local file=${2:-$CONFIG_FILE}
    yq "$path // \"\"" "$file"
}

check_requirements() {
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error "Required command '$cmd' not found"
        fi
    done
}

check_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        error "Configuration file '$CONFIG_FILE' not found"
    fi
}

load_state() {
    if [[ -f "$STATE_FILE" ]]; then
        if [[ -z "$OS" ]]; then
            OS=$(yq_helper '.os' "$STATE_FILE")
        fi
        readarray -t DISABLED < <(yq_helper '.disabled[]' "$STATE_FILE" | grep -v '^$')
        readarray -t INSTALLED < <(yq_helper '.installed[]' "$STATE_FILE" | grep -v '^$')
        log "Loaded state from $STATE_FILE"
    else
        log "No existing state file found at $STATE_FILE"
    fi
}

save_state() {
    {
        echo "os: $OS"
        if (( ${#DISABLED[@]} > 0 )); then
            echo "disabled:"
            printf '%s\n' "${DISABLED[@]}" | sed 's/^/  - /'
        fi
        if (( ${#INSTALLED[@]} > 0 )); then
            echo "installed:"
            printf '%s\n' "${INSTALLED[@]}" | sed 's/^/  - /'
        fi
    } > "$STATE_FILE"
    log "State saved to $STATE_FILE"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -o|--os)
                OS="$2"
                shift 2
                ;;
            --os=*)
                OS="${1#*=}"
                shift
                ;;
            -a|--apps)
                IFS=',' read -ra APPS <<< "$2"
                shift 2
                ;;
            --apps=*)
                IFS=',' read -ra APPS <<< "${1#*=}"
                shift
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done

    # Validate options
    if [[ -z "$OS" ]]; then
        error "Operating system must be specified with --os"
    fi

    if [[ ! " ${VALID_OS[@]} " =~ " ${OS} " ]]; then
        error "Invalid operating system. Must be one of: ${VALID_OS[*]}"
    fi

    # Process all apps by default
    if (( ${#APPS[@]} == 0 )); then
        readarray -t APPS < <(yq_helper 'keys | .[]')
    fi
}

resolve_dependencies() {
    local app=$1
    local deps

    # Check if app should be added to the queue
    if [[ " ${INSTALL_QUEUE[@]} " =~ " ${app} " ]] || \
       [[ " ${INSTALLED[@]} " =~ " ${app} " ]] || \
       [[ " ${DISABLED[@]} " =~ " ${app} " ]]; then
        return
    fi

    deps=$(yq_helper ".$app.dependencies[]")
    if [[ -n "$deps" ]]; then
        for dep in $deps; do
            resolve_dependencies "$dep"
        done
    fi
    INSTALL_QUEUE+=("$app")
}

assign_variables() {
    local app=$1
    local env

    env=$(yq_helper ".$app.env[]")
    if [[ -n "$env" ]]; then
        while IFS=: read -r key value; do
            value=$(eval echo "$value") # evaluate any variables in the value
            export "$key"="$value"
        done <<< "$env"
    fi
}

run_install() {
    local app=$1
    local install_cmd

    install_cmd=$(yq_helper ".$app.install")
    if [[  -n "$install_cmd" && $(yq_helper ".$app.install | type") == "!!str" ]]; then
        log "Running default installation commands for $app"
        eval "$install_cmd"
        return
    fi

    install_cmd=$(yq_helper ".$app.install.$OS")
    if [[ -n "$install_cmd" ]]; then
        log "Running installation commands for $app"
        eval "$install_cmd"
    fi
}

run_setup() {
    local app=$1
    local setup_cmd

    setup_cmd=$(yq_helper ".$app.setup")
    if [[ -n "$setup_cmd" ]]; then
        log "Running setup commands for $app"
        eval "$setup_cmd"
    fi
}

create_symlinks() {
    local app=$1
    local symlink
    local scope

    symlink=$(yq_helper ".$app.symlink")
    scope=$(yq_helper ".$app.scope")

    if [[ -n "$symlink" && -d "$REPO_ROOT/$app" ]]; then
        symlink=$(eval echo "$symlink") # evaluate any variables in the value
        mkdir -p "$symlink"

        if [[ "$scope" == "directory" ]]; then
            # Symlink the entire directory
            if [[ -e "$symlink/$app" ]]; then
                log "Backing up existing $symlink/$app to $symlink/${app}.bak"
                mv "$symlink/$app" "$symlink/${app}.bak"
            fi
            log "Creating symlink for directory: $symlink/$app -> $REPO_ROOT/$app"
            ln -sf "$REPO_ROOT/$app" "$symlink"
        else
            # Symlink each item in the directory
            find "$REPO_ROOT/$app" -maxdepth 1 -mindepth 1 | while read -r item; do
                local target
                target="$symlink/$(basename "$item")"
                if [[ -e "$target" ]]; then
                    log "Backing up existing $target to ${target}.bak"
                    mv "$target" "${target}.bak"
                fi
                log "Creating symlink: $target -> $item"
                ln -sf "$item" "$symlink"
            done
        fi
    fi
}

run_post_setup() {
    local app=$1
    local post_setup_cmd

    post_setup_cmd=$(yq_helper ".$app.post_setup")
    if [[ -n "$post_setup_cmd" ]]; then
        log "Running post setup commands for $app"
        eval "$post_setup_cmd"
    fi
}

main() {
    check_requirements
    check_config
    load_state
    parse_args "$@"

    for app in "${APPS[@]}"; do
        resolve_dependencies "$app"
    done

    if (( ${#INSTALL_QUEUE[@]} == 0 )); then
        success "All apps are already configured!"
        exit 0
    fi
    log "Installation order: ${INSTALL_QUEUE[*]}"

    for app in "${INSTALL_QUEUE[@]}"; do
        log "Processing $app..."

        assign_variables "$app"
        run_install "$app"
        run_setup "$app"
        create_symlinks "$app"
        run_post_setup "$app"

        INSTALLED+=("$app")
        save_state

        success "$app installed and configured successfully"
    done
}

main "$@"

#!/bin/sh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
VIMRC_PATH="$SCRIPT_DIR/.vimrc"
TMUX_CONF_PATH="$SCRIPT_DIR/.tmux.conf"

toggle_theme() {
    local file_path="$1"
    local light_pattern="$2"
    local dark_pattern="$3"

    if grep -q "^$light_pattern" "$file_path"; then
        sed "s/^$light_pattern/$dark_pattern/" "$file_path" > "$file_path.tmp"
        mv "$file_path.tmp" "$file_path"
        echo "Switched to dark theme in $file_path."
    elif grep -q "^$dark_pattern" "$file_path"; then
        sed "s/^$dark_pattern/$light_pattern/" "$file_path" > "$file_path.tmp"
        mv "$file_path.tmp" "$file_path"
        echo "Switched to light theme in $file_path."
    fi
}

toggle_theme "$VIMRC_PATH" 'colorscheme onehalflight' 'colorscheme onehalfdark'
toggle_theme "$TMUX_CONF_PATH" 'set -g @catppuccin_flavor "latte"' 'set -g @catppuccin_flavor "mocha"'
tmux source-file "$TMUX_CONF_PATH"

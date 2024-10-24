#!/bin/sh

# Usage: ./install.sh [--with-deps] [--with-fonts]

with_deps=false
with_fonts=false

for arg in "$@"; do
    case "$arg" in
    --with-deps)
        with_deps=true
        ;;
    --with-fonts)
        with_fonts=true
        ;;
    *)
        echo "Error: Unknown argument '$arg'"
        echo "Usage: $0 [--with-deps] [--with-fonts]"
        exit 1
        ;;
    esac
done

OH_MY_ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins/tpm"
FONT_DIR="$HOME/.local/share/fonts"

PACKAGE_MGR="apt"

install_dependencies() {
    echo "==> Installing dependencies..."
    sudo ${PACKAGE_MGR} update
    sudo ${PACKAGE_MGR} install -y git wget curl zsh tmux vim direnv

    # Check if direnv package installed successfully
    if ! command -v direnv 2>&1 >/dev/null; then
        echo "direnv package not found. Installing binary..."
        curl -sfL https://direnv.net/install.sh | bash
    fi
}

install_zsh() {
    echo "==> Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ $? -ne 0 ]; then
        echo "Error installing oh-my-zsh!"
        exit 1
    fi

    echo "==> Installing oh-my-zsh plugins..."
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "${OH_MY_ZSH_CUSTOM}/plugins/autoupdate"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${OH_MY_ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${OH_MY_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

    echo "==> Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

symlink_configs() {
    echo "==> Symlinking config files..."
    PARENT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")
    mkdir -p "$HOME/.config"
    ln -sf "$PARENT_DIR/.config/nvim" "$HOME/.config"
    ln -sf "$PARENT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
    ln -sf "$PARENT_DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$PARENT_DIR/.vimrc" "$HOME/.vimrc"
    ln -sf "$PARENT_DIR/.zshrc" "$HOME/.zshrc"
}

install_tpm() {
    echo "==> Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR"
    if [ $? -ne 0 ]; then
        echo "Error installing Tmux Plugin Manager!"
        exit 1
    fi

    echo "==> Installing tmux plugins..."
    "$TMUX_PLUGIN_DIR/bin/install_plugins"
}

install_fonts() {
    echo "==> Installing fonts..."
    mkdir -p "$FONT_DIR/FiraCode"
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.tar.xz
    tar -xf FiraCode.tar.xz -C "$FONT_DIR/FiraCode"
    rm FiraCode.tar.xz
    fc-cache -fv
}

if $with_deps; then
    install_dependencies
fi

if $with_fonts; then
    install_fonts
fi

install_zsh
symlink_configs
install_tpm

echo "Installation complete!"

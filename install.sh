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

install_dependencies() {
    echo "==> Installing dependencies..."
    apt-get update
    apt-get install -y git wget curl zsh tmux vim
    chsh -s /bin/zsh
}

install_zsh() {
    echo "==> Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ $? -ne 0 ]; then
        echo "Error installing oh-my-zsh!"
        exit 1
    fi

    echo "==> Installing oh-my-zsh plugins..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${OH_MY_ZSH_CUSTOM}/themes/powerlevel10k"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "${OH_MY_ZSH_CUSTOM}/plugins/autoupdate"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${OH_MY_ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${OH_MY_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
}

symlink_configs() {
    echo "==> Symlinking config files..."
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$SCRIPT_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    ln -sf "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"
    ln -sf "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc"
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
    mkdir -p "$FONT_DIR/MesloLGS NF"
    wget -P "$FONT_DIR/MesloLGS NF" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    wget -P "$FONT_DIR/MesloLGS NF" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    wget -P "$FONT_DIR/MesloLGS NF" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    wget -P "$FONT_DIR/MesloLGS NF" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
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

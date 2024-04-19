#!/bin/sh

# Usage: ./install.sh [--with-deps] [--with-fonts]

install_deps=false   # Default value
install_fonts=false  # Default value

# Parse command-line arguments
while [ "$1" != "" ]; do
    case $1 in
        --with-deps ) install_deps=true
                         shift ;;
        --with-fonts ) install_fonts=true
                          shift ;;
        * )               echo "Unknown argument: $1"
                          exit 1
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

install_oh_my_zsh() {
    echo "==> Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    if [ $? -ne 0 ]; then
        echo "Error installing oh-my-zsh!"
        exit 1
    fi
}

install_zsh_plugins() {
    echo "==> Installing zsh plugins..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${OH_MY_ZSH_CUSTOM}/themes/powerlevel10k"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "${OH_MY_ZSH_CUSTOM}/plugins/autoupdate"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${OH_MY_ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${OH_MY_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
}

symlink_configs() {
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

    echo "==> Symlinking configuration files..."
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

if $install_deps; then
    install_dependencies
fi

install_oh_my_zsh
install_zsh_plugins
symlink_configs
install_tpm

if $install_fonts; then
    install_fonts
fi

echo "Installation complete!"

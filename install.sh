#!/bin/sh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
FONT_DIR=$HOME/.local/share/fonts

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Installing zsh plugins"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing fonts"
mkdir -p $FONT_DIR
wget -P $FONT_DIR https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget -P $FONT_DIR https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget -P $FONT_DIR https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget -P $FONT_DIR https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

echo "Symlinking zsh config files"
ln -sf $SCRIPT_DIR/.zshrc $HOME/.zshrc
ln -sf $SCRIPT_DIR/.p10k.zsh $HOME/.p10k.zsh

echo "Installing Tmux Plugin Manager (tpm)"
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

echo "Symlinking .tmux.conf"
ln -sf $SCRIPT_DIR/.tmux.conf $HOME/.tmux.conf

echo "Installing tmux plugins"
$HOME/.tmux/plugins/tpm/bin/install_plugins

echo "Symlinking .vimrc"
ln -sf $SCRIPT_DIR/.vimrc $HOME/.vimrc

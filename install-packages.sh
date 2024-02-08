#!/bin/sh
sudo apt update
sudo apt install -y \
    curl \
    git \
    tmux \
    xsel \
    xclip \
    vim-gtk3 \
    build-essential \
    gparted \
    htop \
    cifs-utils \
    openssh-server \
    openvpn \
    virt-manager \
    spice-client-gtk \
    krdc \
    krfb \
    borgbackup \
    borgmatic \
    timeshift \
    flameshot \
    filelight \
    vlc \
    ffmpeg \
    obs-studio \
    awscli

# GitHub CLI
type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

# Prep for Docker Desktop
sudo apt remove -y docker-desktop
rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge -y docker-desktop
sudo apt install -y gnome-terminal

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Docker Desktop
wget -O /tmp/docker-desktop.deb 'https://desktop.docker.com/linux/main/amd64/docker-desktop-4.25.1-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64'
sudo apt-get install -y /tmp/docker-desktop.deb

# VSCode
wget -O /tmp/vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt install -y /tmp/vscode.deb

# Obsidian
wget -O /tmp/obsidian.deb 'https://github.com/obsidianmd/obsidian-releases/releases/download/v1.4.16/obsidian_1.4.16_amd64.deb'
sudo apt install -y /tmp/obsidian.deb

# Discord
wget -O /tmp/discord.deb 'https://discord.com/api/download?platform=linux&format=deb'
sudo apt install -y /tmp/discord.deb

# Bitwarden
wget -O /tmp/bitwarden.deb 'https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb'
sudo apt install -y /tmp/bitwarden.deb

# pyenv
sudo apt install -y \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev \
  xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash

# n
curl -L https://bit.ly/n-install | bash -s -- -y

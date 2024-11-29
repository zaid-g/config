#!/bin/bash
# run this file without sudo

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

## packages & setup environment
sudo apt update -y
sudo apt upgrade -y
sudo apt install git python3 python3-venv python3-pip zsh wget curl unzip golang tmux htop xournal ccls meshlab freecad imagemagick -y
bash ~/doc/apps/config/vim/nvim-install-update.sh
bash ~/doc/apps/config/vim/nvim-plugins-install-update.sh
bash ~/doc/apps/config/apply_config.sh

## zsh
# default shell
sudo chsh -s $(which zsh) $(whoami)

# Language servers
curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
go install github.com/mattn/efm-langserver@latest
echo 'export PATH="/home/$USER/go/bin:$PATH"' >> ~/.zshrc

# cleanup
sudo apt autoremove -y

# optional stuff
sudo apt-get install texlive-full

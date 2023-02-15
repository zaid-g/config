#!/bin/bash
# run this file without sudo

## Notes:
# for remapping capslock, download PowerToys
# ---------------

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

## packages & setup environment
sudo apt update -y
sudo apt upgrade -y
sudo apt install git python3 python3-venv python3-pip zsh wget curl golang tmux htop xournal ccls xclip meshlab freecad -y
bash ~/doc/projects/config/vim/nvim-install-update.sh
bash ~/doc/projects/config/vim/nvim-plugins-install-update.sh
bash ~/doc/projects/config/apply_config.sh
PIP3

## zsh
# default shell
sudo chsh -s $(which zsh) $(whoami)

# Language servers
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
go install github.com/mattn/efm-langserver@latest
echo 'export PATH="/home/$USER/go/bin:$PATH"' >> ~/.zshrc

# cleanup
sudo apt autoremove -y

# optional stuff
sudo apt-get install texlive-full

#!/bin/bash
# run this file without sudo

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

## keyboard settings
# swap capslock with escape
dconf write "/org/gnome/desktop/input-sources/xkb-options" "[ 'caps:swapescape']"
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 20
gsettings set org.gnome.desktop.peripherals.keyboard delay 250

## packages & setup environment
sudo apt update -y
sudo apt upgrade -y
sudo apt install git python3 python3-venv python3-pip zsh wget curl golang tmux htop xournal ccls -y
. ~/doc/projects/config/vim/nvim-install-update.sh
. ~/doc/projects/config/vim/nvim-plugins-install-update.sh
. ~/doc/projects/config/apply_config.sh
# get neovim and basic python libraries
pip3 install -r ~/doc/projects/config/python/python-packages-install.txt

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

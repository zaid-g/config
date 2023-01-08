#!/bin/bash
# run this file without sudo

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

## packages & setup environment
sudo apt install git python3 python3-venv python3-pip zsh wget curl golang tmux htop xournal ccls -y
. ~/doc/projects/config/vim/nvim-install-update.sh
. ~/doc/projects/config/vim/nvim-plugins-install-update.sh
. ~/doc/projects/config/apply_config.sh
# get neovim and basic python libraries
pip3 install -r ~/doc/projects/config/python/python-packages-install.txt

## zsh
# default shell
sudo chsh -s $(which zsh) $(whoami)
echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc

# Language servers
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
go install github.com/mattn/efm-langserver@latest

# cleanup
sudo apt autoremove

# optional stuff
sudo apt-get install texlive-full

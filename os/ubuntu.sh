#!/bin/bash

# run this file without sudo
sudo touch ~/misc


sudo apt install git python3 python3-venv python3-pip -y
. ~/doc/projects/config/scripts/update.sh
. ~/doc/projects/config/scripts/nvim-install-update.sh
. ~/doc/projects/config/scripts/nvim-plugins-install-update.sh

set -e # break script if any command fails after this line

pip3 install -r ~/doc/projects/config/scripts/python-packages-install.txt

echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc
echo '. ~/.xinitrc' >> ~/.zshrc

sudo apt install zsh ruby-dev ruby-bundler wget curl golang tmux postgresql postgresql-contrib htop xournal ccls -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
GO111MODULE=on go get github.com/mattn/efm-langserver@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc
chsh -s /usr/bin/zsh

sudo apt autoremove

sudo apt-get install texlive-full -y --fix-missing

# change resolution 1600x900
# change keyboard repeat keys delay and speed 225, 40
# install discord
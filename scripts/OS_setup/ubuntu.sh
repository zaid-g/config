#!/bin/bash

# run this file without sudo but make sure sudo no need pwd (run sudo command b4)
sudo touch /hi

set -e # break script if any command fails

sudo apt-get install git -y
mkdir -p ~/doc/projects
cd ~/doc/projects
git clone https://github.com/zaid-g/config.git
cd ~/doc/projects/config
. ./scripts/update.sh
. ./scripts/nvim-install-update.sh
. ./scripts/nvim-plugins-install-update.sh
pip3 install -r ./scripts/python-packages-install.txt
echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc
echo '. ~/.xinitrc' >> ~/.zshrc

sudo apt install zsh python3-pip python3-venv ruby-dev ruby-bundler wget curl golang tmux postgresql postgresql-contrib xclip htop xournal ccls -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
GO111MODULE=on go get github.com/mattn/efm-langserver@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc
chsh -s /usr/bin/zsh

sudo apt-get install texlive-full -y --fix-missing

# change resolution 1600x900
# change keyboard repeat keys delay and speed 225, 40
# install discord

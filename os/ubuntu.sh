#!/bin/bash
# run this file without sudo

# for sudo
sudo touch ~/misc

# environment
sudo apt install git python3 python3-venv python3-pip -y
. ~/doc/projects/config/vim/nvim-install-update.sh
. ~/doc/projects/config/vim/nvim-plugins-install-update.sh
. ~/doc/projects/config/fetch_and_apply_config.sh

set -e # break script if any command fails after this line

sudo chsh -s $(which zsh) $(whoami)

pip3 install -r ~/doc/projects/config/python/python-packages-install.txt

echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc
echo '. ~/.xinitrc' >> ~/.zshrc

sudo apt install zsh wget curl golang tmux htop xournal ccls -y
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
sudo npm i -g vscode-langservers-extracted
GO111MODULE=on go get github.com/mattn/efm-langserver@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc

sudo apt autoremove

sudo apt-get install texlive-full -y --fix-missing

# change resolution 1600x900
# change keyboard repeat keys delay and speed 225, 40
# install discord

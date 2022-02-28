#!/bin/bash
set -e # any failure will cause script to exit

# run this file without sudo

sudo apt-get install git -y
mkdir ~/dev
cd ~/dev
git clone https://github.com/zaid-g/environment.git
cd ~/dev/environment
. ./update.sh
. ./nvim-install-update.sh
. ./nvim-plugins-install-update.sh
pip3 install -r ./python-packages-install.txt
echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc
echo '. ~/.xinitrc' >> ~/.zshrc

sudo apt install zsh python3-pip python3-venv vim ruby-dev ruby-bundler wget curl golang tmux postgresql postgresql-contrib xclip -y
sudo apt-get install texlive-full -y --fix-missing
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
chsh -s /usr/bin/zsh
GO111MODULE=on go get github.com/mattn/efm-langserver@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc

# change resolution 1600x900
# change keyboard repeat keys delay and speed 200, 50

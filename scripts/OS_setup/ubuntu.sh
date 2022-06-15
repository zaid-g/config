#!/bin/bash
# run this file without sudo

sudo apt-get install git -y
mkdir ~/dev
cd ~/dev
git clone https://github.com/zaid-g/environment.git
cd ~/dev/environment
. ./scripts/update.sh
. ./scripts/nvim-install-update.sh
. ./scripts/nvim-plugins-install-update.sh
pip3 install -r ./scripts/python-packages-install.txt
echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> ~/.zshrc
echo '. ~/.xinitrc' >> ~/.zshrc

sudo apt install zsh python3-pip python3-venv ruby-dev ruby-bundler wget curl golang tmux postgresql postgresql-contrib xclip htop xournal -y
sudo apt-get install texlive-full -y --fix-missing
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo npm i -g pyright
GO111MODULE=on go get github.com/mattn/efm-langserver@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.zshrc
chsh -s /usr/bin/zsh

# change resolution 1600x900
# change keyboard repeat keys delay and speed 200, 50

# install discord and snap
sudo apt install snapd -y
#reboot
sudo snap install core
sudo snap install discord
# to update
sudo snap refresh
# to run
#snap run discord
## to remove
#sudo snap remove discord

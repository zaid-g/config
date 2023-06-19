#!/bin/bash
# run this file without sudo

## Notes:
# for remapping capslock, download PowerToys
# for controlling backlight, turn off HDR in display settings windows
# ---------------

set -e # break script if any command fails after this line

# for sudo
sudo echo "Running ..."

# win32yank.exe for neovim clipboard
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
# echo "set clipboard=unnamedplus" >> ~/.config/nvim/init.vim

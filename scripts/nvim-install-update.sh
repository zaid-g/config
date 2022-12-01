set -e

current_working_directory=$(PWD)
rm -rf ~/app/neovim
mkdir -p ~/app/neovim/
# linux appimage
cd ~/app/neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
# os x binary
cd ~/app/neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz
cd $current_working_directory

set -e

rm -rf ~/app/neovim
mkdir -p ~/app/neovim/
# linux appimage
cd ~/app/neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mv squashfs-root squashfs-root
# os x binary
cd ~/app/neovim
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
tar xzf nvim-macos.tar.gz

rm -rf ~/app/neovim
mkdir -p ~/app/neovim
cd ~/app/neovim
# get version
nvim_latest_version=$(curl -s https://github.com/neovim/neovim/releases/latest)
nvim_latest_version=$(echo $nvim_latest_version | grep -o '".*"')
nvim_latest_version="${nvim_latest_version:47:-1}"
# get download link
nvim_base_download_link=https://github.com/neovim/neovim/releases/download/${nvim_latest_version}
# append assets
nvim_appimage_link=$nvim_base_download_link/nvim.appimage
nvim_appimage_checksum_link=$nvim_base_download_link/nvim.appimage.sha256sum
nvim_linux64_link=$nvim_base_download_link/nvim-linux64.tar.gz
nvim_linux64_checksum_link=$nvim_base_download_link/nvim-linux64.tar.gz.sha256sum
# download
wget $nvim_appimage_link
wget $nvim_appimage_checksum_link
wget $nvim_linux64_link
wget $nvim_linux64_checksum_link
# check shasums
sha256sum -c nvim.appimage.sha256sum
sha256sum -c nvim-linux64.tar.gz.sha256sum
# decompress the tar linux code
tar -zxf nvim-linux64.tar.gz
cd ~/dev/environment/scripts

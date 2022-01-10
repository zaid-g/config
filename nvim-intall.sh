mkdir -p ~/app/neovim
cd ~/app
nvim_latest_github_path=$(curl -s https://github.com/neovim/neovim/releases/latest | grep -Po '".*"' )
# cut " "
nvim_latest_github_path="${nvim_latest_github_path:1:-1}"
# append assets
nvim_appimage_link=$nvim_latest_github_path/nvim.appimage
nvim_appimage_checksum_link=$nvim_latest_github_path/nvim.appimage.sha256sum
nvim_linux64_link=$nvim_latest_github_path/nvim-linux64.tar.gz
nvim_linux64_checksum_link=$nvim_latest_github_path/nvim-linux64.tar.gz.sha256sum
# download
wget nvim_appimage_link
wget nvim_appimage_checksum_link
wget nvim_linux64_link
wget nvim_linux64_checksum_link
# check shasums
sha256sum -c nvim.appimage.sha256sum
sha256sum -c nvim-linux64.tar.gz.sha256sum

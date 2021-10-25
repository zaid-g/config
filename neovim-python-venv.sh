mkdir -p ~/env/
cd ~/env
python3 -m venv nvim
. ./nvim/bin/activate
pip3 install wheel
pip3 install neovim
pip3 install black
pip3 install 'python-lsp-server[all]'
pip3 install python-lsp-black
pip3 uninstall -y autopep8
pip3 uninstall -y yapf
cd dotfiles

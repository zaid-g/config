#make dirs
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/doc/projects
mkdir -p ~/misc/
mkdir -p ~/pic/
mkdir -p ~/.config/nvim
mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.ipython/profile_default
cd ~/doc/projects

#remove old repo
rm -rf config
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/config.git
git clone https://github.com/zaid-g/config.git
cd config

## source config files
# neovim
touch -a ~/.config/nvim/init.vim
grep -qF 'luafile ~/doc/projects/config/init.lua' ~/.config/nvim/init.vim || echo "$(cat ~/.config/nvim/init.vim;printf 'luafile ~/doc/projects/config/init.lua\n')" > ~/.config/nvim/init.vim
grep -qF 'source ~/doc/projects/config/vimrc' ~/.config/nvim/init.vim || echo "$(printf 'source ~/doc/projects/config/vimrc\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
# vim
touch -a ~/.vimrc
grep -qF 'source ~/doc/projects/config/vimrc' ~/.vimrc || echo "$(printf 'source ~/doc/projects/config/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
# zsh
touch -a ~/.zshrc
grep -qF '. ~/doc/projects/config/zshrc' ~/.zshrc || echo "$(printf '. ~/doc/projects/config/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
# tmux
touch -a ~/.tmux.conf
grep -qF 'source-file ~/doc/projects/config/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/doc/projects/config/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf
# pycodestyle
cp pycodestyle ~/.config/
# ipython
cp ipython_config.py ~/.ipython/profile_default/
# sway
cp sway/* ~/.config/sway/

# return to scripts dir
cd ~/doc/projects/config/scripts

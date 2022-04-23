#make dirs
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/dev/
mkdir -p ~/doc/
mkdir -p ~/misc/
mkdir -p ~/pic/
mkdir -p ~/.config/nvim
mkdir -p ~/.ipython/profile_default
cd ~/dev

#remove old repo
rm -rf environment
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/environment.git
git clone https://github.com/zaid-g/environment.git
cd environment

## source config files
# neovim
touch -a ~/.config/nvim/init.vim
grep -qF 'luafile ~/dev/environment/init.lua' ~/.config/nvim/init.vim || echo "$(cat ~/.config/nvim/init.vim;printf 'luafile ~/dev/environment/init.lua\n')" > ~/.config/nvim/init.vim
grep -qF 'source ~/dev/environment/vimrc' ~/.config/nvim/init.vim || echo "$(printf 'source ~/dev/environment/vimrc\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
# vim
touch -a ~/.vimrc
grep -qF 'source ~/dev/environment/vimrc' ~/.vimrc || echo "$(printf 'source ~/dev/environment/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
# zsh
touch -a ~/.zshrc
grep -qF '. ~/dev/environment/zshrc' ~/.zshrc || echo "$(printf '. ~/dev/environment/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
# tmux
touch -a ~/.tmux.conf
grep -qF 'source-file ~/dev/environment/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/dev/environment/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf
# pycodestyle
cp pycodestyle ~/.config/
# ipython
cp ipython_config.py ~/.ipython/profile_default/

# X switch capslock with escape
touch -a ~/.xinitrc
grep -qF 'setxkbmap -option caps:swapescape' ~/.xinitrc || echo "$(printf 'setxkbmap -option caps:swapescape\n'; cat ~/.xinitrc)" > ~/.xinitrc
grep -qF 'xset r rate 225 40' ~/.xinitrc || echo "$(printf 'xset r rate 225 40\n'; cat ~/.xinitrc)" > ~/.xinitrc

# return to scripts dir
cd ~/dev/environment/scripts

#make dirs
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/dev/
mkdir -p ~/doc/
mkdir -p ~/env/
mkdir -p ~/misc/
mkdir -p ~/pic/
mkdir -p ~/env/Docker/main
mkdir -p ~/.config/nvim
mkdir -p ~/.ipython/profile_default
cd ~/env

#remove old repo
rm -rf dotfiles
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/dotfiles.git
git clone https://github.com/zaid-g/dotfiles.git
cd dotfiles

## source config files
# neovim
touch -a ~/.config/nvim/init.vim
grep -qxF 'luafile ~/env/dotfiles/init.lua' ~/.config/nvim/init.vim || echo "$(cat ~/.config/nvim/init.vim;printf 'luafile ~/env/dotfiles/init.lua\n')" > ~/.config/nvim/init.vim
grep -qxF 'source ~/env/dotfiles/vimrc' ~/.config/nvim/init.vim || echo "$(printf 'source ~/env/dotfiles/vimrc\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
# vim
touch -a ~/.vimrc
grep -qxF 'source ~/env/dotfiles/vimrc' ~/.vimrc || echo "$(printf 'source ~/env/dotfiles/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
# zsh
touch -a ~/.zshrc
grep -qxF '. ~/env/dotfiles/zshrc' ~/.zshrc || echo "$(printf '. ~/env/dotfiles/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
# tmux
touch -a ~/.tmux.conf
grep -qxF 'source-file ~/env/dotfiles/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/env/dotfiles/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf
# pycodestyle
cp pycodestyle ~/.config/
# ipython
cp ipython_config.py ~/.ipython/profile_default/

# X switch capslock with escape
touch -a ~/.xinitrc
grep -qxF 'setxkbmap -option caps:swapescape' ~/.xinitrc || echo "$(printf 'setxkbmap -option caps:swapescape\n'; cat ~/.xinitrc)" > ~/.xinitrc
grep -qxF 'xset r rate 225 40' ~/.xinitrc || echo "$(printf 'xset r rate 225 40\n'; cat ~/.xinitrc)" > ~/.xinitrc

# return to dotfiles dir
cd ~/env/dotfiles

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
cd ~/env

#remove old repo
rm -rf dotfiles
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/dotfiles.git
git clone https://github.com/zaid-g/dotfiles.git
#update home dir dotfiles
cd dotfiles
# dockerfile copy into env folder
cp Dockerfile ~/env/Docker/main

## source config files
# neovim
touch -a ~/.config/nvim/init.vim
grep -qxF 'luafile ~/env/dotfiles/init.lua' ~/.config/nvim/init.vim || echo "$(printf 'luafile ~/env/dotfiles/init.lua\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
grep -qxF 'source ~/env/dotfiles/vimrc' ~/.config/nvim/init.vim || echo "$(printf 'source ~/env/dotfiles/vimrc\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
# vimrc
touch -a ~/.vimrc
grep -qxF 'source ~/env/dotfiles/vimrc' ~/.vimrc || echo "$(printf 'source ~/env/dotfiles/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
# zshrc
touch -a ~/.zshrc
grep -qxF '. ~/env/dotfiles/zshrc' ~/.zshrc || echo "$(printf '. ~/env/dotfiles/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
# tmux conf file
touch -a ~/.tmux.conf
grep -qxF 'source-file ~/env/dotfiles/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/env/dotfiles/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf

# X switch capslock with escape
touch -a ~/.xinitrc
grep -qxF 'setxkbmap -option caps:swapescape' ~/.xinitrc || echo "$(printf 'setxkbmap -option caps:swapescape\n'; cat ~/.xinitrc)" > ~/.xinitrc
grep -qxF 'xset r rate 225 40' ~/.xinitrc || echo "$(printf 'xset r rate 225 40\n'; cat ~/.xinitrc)" > ~/.xinitrc

#python profile vim mode
mkdir -p ~/.ipython/profile_default
touch -a ~/.ipython/profile_default/ipython_config.py
grep -qxF "c.TerminalInteractiveShell.editing_mode = 'vi'" ~/.ipython/profile_default/ipython_config.py || echo "c.TerminalInteractiveShell.editing_mode = 'vi'" >> ~/.ipython/profile_default/ipython_config.py
cd ~/env/dotfiles

#make dirs
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/dev/
mkdir -p ~/doc/
mkdir -p ~/env/
mkdir -p ~/misc/
mkdir -p ~/pic/
mkdir -p ~/env/Docker/main
cd ~/env
#remove old repo
rm -rf dotfiles
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/dotfiles.git
git clone https://github.com/zaid-g/dotfiles.git
#update home dir dotfiles
cp Dockerfile ~/env/Docker/main
cd dotfiles
touch -a ~/.zshrc
touch -a ~/.tmux.conf
touch -a ~/.vimrc
grep -qxF 'source ~/env/dotfiles/vimrc' ~/.vimrc || echo "$(printf 'source ~/env/dotfiles/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
grep -qxF '. ~/env/dotfiles/zshrc' ~/.zshrc || echo "$(printf '. ~/env/dotfiles/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
grep -qxF 'source-file ~/env/dotfiles/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/env/dotfiles/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf

# X switch capslock with escape
touch -a ~/.xinitrc
grep -qxF 'setxkbmap -option caps:swapescape' ~/.xinitrc || echo "$(printf 'setxkbmap -option caps:swapescape\n'; cat ~/.xinitrc)" > ~/.xinitrc
grep -qxF 'xset r rate 175 40' ~/.xinitrc || echo "$(printf 'xset r rate 175 40\n'; cat ~/.xinitrc)" > ~/.xinitrc

#python profile vim mode
mkdir -p ~/.ipython/profile_default
touch -a ~/.ipython/profile_default/ipython_config.py
grep -qxF "c.TerminalInteractiveShell.editing_mode = 'vi'" ~/.ipython/profile_default/ipython_config.py || echo "c.TerminalInteractiveShell.editing_mode = 'vi'" >> ~/.ipython/profile_default/ipython_config.py
cd ~/env/dotfiles

#remove old repo
mkdir -p ~/dev/
cd ~/dev
rm -rf dotfiles
#clone new repo, try ssh first so if key exists u can push
git clone git@github.com:zaid-g/dotfiles.git
git clone https://github.com/zaid-g/dotfiles.git
#update home dir dotfiles
cd dotfiles
touch -a ~/.zshrc
touch -a ~/.tmux.conf
touch -a ~/.vimrc
grep -qxF 'source ~/dev/dotfiles/vimrc' ~/.vimrc || echo "$(echo -n 'source ~/dev/dotfiles/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
grep -qxF '. ~/dev/dotfiles/zshrc' ~/.zshrc || echo "$(echo -n '. ~/dev/dotfiles/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
grep -qxF 'source-file ~/dev/dotfiles/tmux.conf' ~/.tmux.conf || echo "$(echo -n 'source-file ~/dev/dotfiles/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf

# X switch capslock with escape
touch -a ~/.xinitrc
grep -qxF 'setxkbmap -option caps:swapescape' ~/.xinitrc || echo "$(echo -n 'setxkbmap -option caps:swapescape\n'; cat ~/.xinitrc)" > ~/.xinitrc

#python profile vim mode
mkdir -p ~/.ipython/profile_default
touch -a ~/.ipython/profile_default/ipython_config.py
grep -qxF "c.TerminalInteractiveShell.editing_mode = 'vi'" ~/.ipython/profile_default/ipython_config.py || echo "c.TerminalInteractiveShell.editing_mode = 'vi'" >> ~/.ipython/profile_default/ipython_config.py

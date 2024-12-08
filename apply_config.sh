#make dirs
echo "***      Creating Dirs         ***"
mkdir -p ~/doc
mkdir -p ~/app/
mkdir -p ~/dat/
mkdir -p ~/misc/
mkdir -p ~/pic/
mkdir -p ~/.config/nvim
mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.config/alacritty
mkdir -p ~/.ipython/profile_default

## source config files
echo "***         Sourcing Files         ***"
# nvim
touch -a ~/.config/nvim/init.vim
grep -qF 'luafile ~/doc/config/vim/init.lua' ~/.config/nvim/init.vim || echo "$(cat ~/.config/nvim/init.vim;printf 'luafile ~/doc/config/vim/init.lua\n')" > ~/.config/nvim/init.vim
grep -qF 'source ~/doc/config/vim/vimrc' ~/.config/nvim/init.vim || echo "$(printf 'source ~/doc/config/vim/vimrc\n'; cat ~/.config/nvim/init.vim)" > ~/.config/nvim/init.vim
# vim
touch -a ~/.vimrc
grep -qF 'source ~/doc/config/vim/vimrc' ~/.vimrc || echo "$(printf 'source ~/doc/config/vim/vimrc\n'; cat ~/.vimrc)" > ~/.vimrc
# zsh
touch -a ~/.zshrc
grep -qF '. ~/doc/config/zsh/zshrc' ~/.zshrc || echo "$(printf '. ~/doc/config/zsh/zshrc\n'; cat ~/.zshrc)" > ~/.zshrc
# tmux
touch -a ~/.tmux.conf
grep -qF 'source-file ~/doc/config/tmux/tmux.conf' ~/.tmux.conf || echo "$(printf 'source-file ~/doc/config/tmux/tmux.conf\n'; cat ~/.tmux.conf)" > ~/.tmux.conf
# pycodestyle
cp ~/doc/config/python/pycodestyle ~/.config/
# ipython
cp ~/doc/config/python/ipython_config.py ~/.ipython/profile_default/
# sway
cp ~/doc/config/sway/* ~/.config/sway/
# alacritty
cp ~/doc/config/alacritty/* ~/.config/alacritty/
chmod +x ~/.config/sway/clamshell.sh
chmod +x ~/.config/sway/status.sh

mkdir -p ~/dev/
cd ~/dev
rm -rf .dotfiles
git clone https://github.com/zaid-g/.dotfiles.git
cd .dotfiles
touch -a ~/.zshrc
touch -a ~/.tmux.conf
touch -a ~/.vimrc
grep -qxF 'source ~/dev/.dotfiles/.vimrc' ~/.vimrc || echo 'source ~/dev/.dotfiles/.vimrc' >> ~/.vimrc
grep -qxF '. ~/dev/.dotfiles/.zshrc' ~/.zshrc || echo '. ~/dev/.dotfiles/.zshrc' >> ~/.zshrc
grep -qxF 'source-file ~/dev/.dotfiles/.tmux.conf' ~/.tmux.conf || echo 'source-file ~/dev/.dotfiles/.tmux.conf' >> ~/.tmux.conf

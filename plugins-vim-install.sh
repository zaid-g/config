rm -rf ~/.vim/pack/myplugins/start
mkdir -p ~/.vim/pack/myplugins/start
cd ~/.vim/pack/myplugins/start
git clone https://github.com/jpalardy/vim-slime.git
git clone https://github.com/simeji/winresizer.git
git clone https://github.com/doums/darcula.git
git clone --depth 1 https://github.com/dense-analysis/ale.git
git clone https://github.com/SirVer/ultisnips.git
git clone git://github.com/honza/vim-snippets.git
grep -qxF 'colo darcula' ~/.vimrc || echo "$(cat ~/.vimrc; printf '\ncolo darcula\n')" > ~/.vimrc
cd ~/env/dotfiles

rm -rf ~/.local/share/nvim/site/pack/myplugins/start
mkdir -p ~/.local/share/nvim/site/pack/myplugins/start
cd ~/.local/share/nvim/site/pack/myplugins/start
git clone https://github.com/jpalardy/vim-slime.git
git clone https://github.com/simeji/winresizer.git
git clone https://github.com/doums/darcula.git
git clone --depth 1 https://github.com/dense-analysis/ale.git
git clone https://github.com/SirVer/ultisnips.git
git clone git://github.com/honza/vim-snippets.git
grep -qxF 'colo darcula' ~/.config/nvim/init.vim || echo "$(cat ~/.config/nvim/init.vim; printf '\ncolo darcula\n')" > ~/.config/nvim/init.vim
cd ~/env/dotfiles

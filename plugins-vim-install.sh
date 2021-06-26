mkdir -p ~/.vim/pack/plugins/start
cd ~/.vim/pack/plugins/start
git clone https://github.com/jpalardy/vim-slime.git
git clone https://github.com/simeji/winresizer.git
git clone https://github.com/doums/darcula.git
git clone --depth 1 https://github.com/dense-analysis/ale.git
git clone https://github.com/SirVer/ultisnips.git
git clone git://github.com/honza/vim-snippets.git
grep -qxF 'colo darcula' ~/.vimrc || echo "$(cat ~/.vimrc; printf '\ncolo darcula\n')" > ~/.vimrc

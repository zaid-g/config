rm -rf ~/.local/share/nvim/site/pack/downloaded/start
mkdir -p ~/.local/share/nvim/site/pack/downloaded/start
cd ~/.local/share/nvim/site/pack/downloaded/start

# send to tmux plugin
git clone https://github.com/jpalardy/vim-slime.git

# resize windows
git clone https://github.com/simeji/winresizer.git

# :Rename, :Delete file commands without buffer complications
git clone https://github.com/tpope/vim-eunuch.git

## Lsp stuff
git clone https://github.com/neovim/nvim-lspconfig.git
# completion stuff including snippets
git clone https://github.com/hrsh7th/nvim-cmp.git
git clone https://github.com/hrsh7th/cmp-nvim-lsp.git
git clone https://github.com/L3MON4D3/LuaSnip.git
git clone https://github.com/saadparwaiz1/cmp_luasnip.git
# abstract syntax tree
git clone https://github.com/nvim-treesitter/nvim-treesitter.git
git clone https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git

# color scheme
git clone https://github.com/briones-gabriel/darcula-solid.nvim.git

# indent blankline
git clone https://github.com/lukas-reineke/indent-blankline.nvim.git

# code comment plugin
git clone https://github.com/numToStr/Comment.nvim.git

# fuzzy finder
git clone https://github.com/nvim-telescope/telescope.nvim.git
git clone https://github.com/nvim-lua/plenary.nvim.git # idk why/if this is needed

nnoremap <C-K> k<C-Y>
nnoremap <C-J> j<C-E>
vmap Y "+y
nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
syntax on
set timeoutlen=1000 ttimeoutlen=0
:nnoremap <C-y> /\(# In\[.*\]:\)\\|\(\%$\)<CR>NjVnk"+yn:noh<CR>j

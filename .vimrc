nnoremap <C-K> k<C-Y>
nnoremap <C-J> j<C-E>
vmap Y "+y
nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
:set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0
:nnoremap C /\(# In\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
:nnoremap I o# In[ ]:<CR>

noremap K k<C-Y>
noremap J j<C-E>
nnoremap <C-J> J
vmap Y "+y
nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
:set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0
:nnoremap C /\(# In\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
:nnoremap I o<CR># In[ ]:<CR><CR>
set laststatus=2
:vmap y ygv<Esc>
xnoremap p pgvy
:map cc :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>b

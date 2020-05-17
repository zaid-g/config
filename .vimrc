" Author: zaid gharaybeh


" allows using default , functionality
nnoremap ,, ,

" redefine tabs as spaces and auto indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" addtional scroll movements
noremap K @="k\<lt>C-Y>"<CR>
noremap J @="j\<lt>C-E>"<CR>
" remap replaced J and K functionality (assumes ctrl-J and ctrl-K are not used
" in normal/visual mode)
noremap <c-j> J
noremap <c-k> K

nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
:set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0

" block abstraction and execution "TODO make below work with beginning of file
:nnoremap ,c /\(# In\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
:nnoremap ,b o<CR># Block[ ]:<CR><CR>

set laststatus=2

" make copy not bounce back to beginning of block
:vmap y ygv<Esc>

" copy to system clipboard "TODO understand how Y works in normal or visual
" mode
vnoremap Y "+y

" allows multiple pasting of copied text
xnoremap p pgvy

" shortcut to highlight whole word under cursor "TODO make this work in visual
" mode
:noremap ,h :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>b 

" Ctags set
set tags=tags

" Parantheses different colors
hi MatchParen cterm=none ctermbg=green ctermfg=blue

if &diff
    " diff mode
    set diffopt+=iwhite
endif

" python specific ipdb set_trace call shortcut
:nnoremap <c-p> Oimport ipdb; ipdb.set_trace()<ESC>

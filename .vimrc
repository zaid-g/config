" redefine tabs as spaces and auto indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" addtional scroll movements
nnoremap K @="k\<lt>C-Y>"<CR>
nnoremap J @="j\<lt>C-E>"<CR>

" remap bringing bottom sentence up
nnoremap <C-J> J

" shortcut to scroll whole page minus 2 lines
function! EmacsPageMovDown()
    let height=winheight(0)
    let key="J" 
    execute 'normal ' . (height-2) . key 
endfunction
function! EmacsPageMovUp() 
    let height=winheight(0)
    let key="K"
    execute 'normal ' . (height-2). key 
endfunction
nnoremap <c-u> :call EmacsPageMovUp()<CR>
nnoremap <c-d> :call EmacsPageMovDown()<CR>

" copy to system clipboard
vmap Y "+y

nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
:set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0

" block abstraction and execution
:nnoremap C /\(# In\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
:nnoremap I o<CR># In[ ]:<CR><CR>

set laststatus=2

" copy doesn't bounce back to beginning of block
:vmap y ygv<Esc>

" allows multiple pasting of copied text
xnoremap p pgvy

" shortcut to highlight whole word under cursor
:map cc :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<C-M>b

" Ctags set
set tags=tags

" Parantheses different colors
hi MatchParen cterm=none ctermbg=green ctermfg=blue

if &diff
    " diff mode
    set diffopt+=iwhite
endif


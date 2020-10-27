"""""""""""""""""""""""""
" Author: Zaid Gharaybeh
"
"""""""""""""""""""""""""
"source <path>





" addtional scroll movements and replace buttons
noremap <silent> J @="j\<lt>C-E>"<CR>
noremap <silent> K @="k\<lt>C-Y>"<CR>
noremap <c-j> J
noremap <c-k> K
" copy now more logical with uppercase (copies from cursor to end of line)
map Y y$
" copy to system clipboard
noremap ,y "+y
noremap ,Y "+Y
" allows multiple pasting of copied text
xnoremap p pgvy
"
nnoremap <Space> :noh<CR>
"
nnoremap <c-p> Oimport ipdb; ipdb.set_trace()<ESC>:w<CR>
" frees up , to use for my own bindings
noremap <c-m> ,


" open all files recursively of type determined after
nnoremap ,n :n **/*.
" block abstraction and execution "TODO make below work with beginning of file
nnoremap ,<C-y> /\(# Block\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
nnoremap ,b o<CR># Block[ ]:<CR><CR>
" ctags
nnoremap ,t :!ctags -R .<CR>:set tags=tags<CR>
" shortcut to highlight whole word under cursor TODO make this work in visual mode
noremap ,h :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>b
" insert python docstring
nnoremap ,idp o"""<CR>ToDo:description<CR><CR><CR>Keyword arguments:<CR>arg1 -- <CR>arg2 -- <CR>"""<ESC>
" replace occurences with incrementing counter appended
nnoremap ,ri :let @a=1 \| %s/search/\='replace'.(@a+setreg('a',@a+1))/g
nnoremap ,sb :botr vs<CR>:b 


"
set hidden
" ctags set
set tags=tags
"
set laststatus=2
"
set sessionoptions-=options " Don't save options so loading session saved with mks doesn't disable cul (set cul)


" redefine tabs as spaces and auto indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab



set hlsearch
set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0


if &diff
    " diff mode
    set diffopt+=iwhite
endif


" for tmux color to be consistent
set background=dark
set t_Co=256

""Package/Plugin settings
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

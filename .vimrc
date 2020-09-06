"""""""""""""""""""""""""
" Author: zaid gharaybeh
"
"""""""""""""""""""""""""

" addtional scroll movements and replace buttons
noremap <silent> J @="j\<lt>C-E>"<CR>
noremap <silent> K @="k\<lt>C-Y>"<CR>
noremap <c-j> J
noremap <c-k> K
" copy to system clipboard TODO understand how Y works in normal or visual mode
vnoremap Y "+y
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
nnoremap ,y /\(# Block\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
nnoremap ,b o<CR># Block[ ]:<CR><CR>
" ctags
nnoremap ,t :!ctags -R .<CR>:set tags=tags<CR>
" shortcut to highlight whole word under cursor TODO make this work in visual mode
noremap ,h :let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>b
" insert python docstring
nnoremap ,idp o"""<CR>ToDo:description<CR><CR><CR>Keyword arguments:<CR>arg1 -- <CR>arg2 -- <CR>"""<ESC>


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


" highlighting
:colo ron
"hi Normal ctermfg=121 ctermbg=0 guifg=lightgreen guibg=Black
hi MatchParen cterm=NONE ctermbg=green ctermfg=white guifg=NONE "paranthesis
set culopt=number
set cursorline
highlight CursorLineNr cterm=NONE ctermbg=darkgrey ctermfg=NONE gui=NONE guibg=#ffffff guifg=#d70000
" make current window more obvious
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

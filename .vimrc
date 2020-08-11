"""""""""""""""""""""""""
" Author: zaid gharaybeh

" Notes
" 1) leader is used to replace default keys that i've remapped

"""""""""""""""""""""""""


" allows using default , functionality
nnoremap ,, ,

" make x cut into black hole register
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
" ,d is like dd but text goes to black hole register
nnoremap ,d V"_x

" redefine tabs as spaces and auto indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" addtional scroll movements
noremap <silent> K @="k\<lt>C-Y>"<CR>
noremap <silent> J @="j\<lt>C-E>"<CR>
" replace buttons 
noremap <c-j> J
noremap <c-k> K
noremap <Leader>k <c-k>


nnoremap <Space> :noh<CR>
filetype plugin indent on
:set hlsearch
:set nu
syntax on
set timeoutlen=1000 ttimeoutlen=0

" block abstraction and execution "TODO make below work with beginning of file
:nnoremap ,c /\(# Block\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
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

" ctags set
set tags=tags
nnoremap ,t :!ctags -R .<CR>:set tags=tags<CR>

if &diff
    " diff mode
    set diffopt+=iwhite
endif

" python specific ipdb set_trace call shortcut
:nnoremap <c-p> Oimport ipdb; ipdb.set_trace()<ESC>

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

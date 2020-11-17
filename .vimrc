"""""""""""""""""""""""""
" Author: Zaid Gharaybeh
"
"""""""""""""""""""""""""
"source <path>





"" Bread and butter
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
noremap m ,
noremap <c-m> m




"" my mappings
" open all files recursively of type determined after
nnoremap ,n :n `find . -not -path '*/\.*' -type f -name '*.'`<Left><Left>
" block abstraction and execution "TODO make below work with beginning of file
nnoremap ,<C-y> /\(# Block\[.*\]:\)\\|\(\%$\)<CR>NjVn"+yn:noh<CR>jzz
nnoremap ,b o<CR># Block[ ]:<CR><CR>
" ctags
noremap ,t :<c-u>!ctags -R .<CR>:set tags=tags<CR>
" shortcut to highlight whole word under cursor TODO make this work in visual mode
noremap ,h :<c-u>let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>wb
" insert python docstring
nnoremap ,idp o"""<CR>ToDo:description<CR><CR><CR>Keyword arguments:<CR>arg1 -- <CR>arg2 -- <CR>"""<ESC>
" replace occurences with incrementing counter appended
nnoremap ,ri :let @a=1 \| %s/search/\='replace'.(@a+setreg('a',@a+1))/g
nnoremap ,sb :botr vs<CR>:b 




" timeout settings
set timeoutlen=1000 ttimeoutlen=0



"" visual options
" highlight search results
set hlsearch
" highlight opposite [({
hi MatchParen cterm=none ctermbg=darkgreen
" set line number
set nu
" set syntax
syntax on
"
set laststatus=2
" make active window more visible
hi StatusLine ctermfg=black ctermbg=darkgreen cterm=bold gui=bold
" for vim to have consistent colors within tmux
set background=dark
set t_Co=256





"" Other options
set hidden
" ctags set
set tags=tags
" redefine tabs as spaces and auto indent
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab






"" Package/Plugin settings
" Slime 
noremap ,sc :<C-u>SlimeConfig<CR>
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ".0"}
let g:slime_dont_ask_default = 1
" winresize
noremap ,w :<C-u>WinResizerStartResize<CR>

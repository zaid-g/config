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
" copy to system clipboard
noremap Y "+y
" allows multiple pasting of copied text
xnoremap p pgvy
" paste from clipboard without ruining indentation using C-b
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
inoremap <c-b> <F2><c-r>+<F2>
" word completion using tab and shift tab (instead of c-n c-p)
" can still use C-t and C-d to insert/remove tabs from text
inoremap <TAB> <c-n>
inoremap <S-TAB> <c-p>
" because of conflict with tmux prefix
vnoremap g<c-n> g<C-g>2gs
nnoremap g<c-n> g<C-g>
"
nnoremap <Space> :noh<CR>
" frees up m to use for my own bindings
noremap mm m



""" my mappings
" bufdo e without loss of syntax highlighting and switching buffers
nnoremap me <c-w>n:bufdo e<CR>:q
" block abstraction and execution: make blocks in file and be able to
" immediately send its contents to another tmux window using Slime or
" to clipboard
nnoremap mbl o<CR># ---------- [] ----------:<CR><CR><ESC>2k13la
nnoremap my :exe "norm! w"<CR>?\%^\\|# ----------<CR>v/\%$\\|# ----------<CR>$:SlimeSend<CR>'>:noh<CR>
nnoremap mY :exe "norm! w"<CR>w?\%^\\|# ----------<CR>v/\%$\\|# ----------<CR>$"+y'>:noh<CR>
" ctags
noremap mT :<c-u>!ctags -R **/*.py<CR>:<c-u>set tags+=tags<CR>:<c-u>!ctags -f tags_venv -R $VIRTUAL_ENV/lib/pytho*/site-packages<CR>:<c-u>set tags+=tags_venv<CR>
noremap mt :<c-u>!ctags -R **/*.py<CR>:<c-u>set tags+=tags<CR>:<c-u>set tags+=tags_venv<CR>
" shortcut to highlight search whole word under cursor
nnoremap ml :<c-u>let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>wb
" shortcut to highlight search what's being selected in visual mode
vnoremap ml :<c-u>let temp_variable=@"<CR>gvy:<c-u>let @/='\V<C-R>=escape(@",'/\')<CR>'<CR>:let @"=temp_variable<CR>:<c-u>set hlsearch<CR>
" change currently searched for pattern
nnoremap mcs :%s/<C-R>=@/<CR>//g<Left><Left>
vnoremap mcs :s/<C-R>=@/<CR>//g<Left><Left>
" change typed pattern
nnoremap mct :%s//g<Left><Left>
vnoremap mct :s//g<Left><Left>
" find and replace in all buffers searched for pattern
nnoremap mbdcs :bufdo %s/<C-R>=@/<CR>//g \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" find and replace in all buffers typed pattern
nnoremap mbdct :bufdo %s///g \| update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" delete to black hole register
noremap mx "_x
" replace occurences with incrementing counter appended
nnoremap mri :let @a=1 \| %s/search/\='replace'.(@a+setreg('a',@a+1))/g
" split window vertically on new column
nnoremap msb :botr vs<CR>:b 
"" python mappings
" ipdb trace above current line
nnoremap mp Oimport ipdb; ipdb.set_trace()<ESC>:w<CR>
" timeit
xnoremap mvt <ESC>`<Oimport time; my_start_time = time.time()<ESC>`>oprint("my_end_time - my_start_time = ", time.time() - my_start_time)<ESC>


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
set autoread
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
noremap mSC :<C-u>SlimeConfig<CR>
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ".0"}
let g:slime_dont_ask_default = 1
" winresize
let g:winresizer_start_key = 'mW'
" Ale stuff
nnoremap mF :ALEFix<CR>
nnoremap mL :ALELint<CR>
let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['black']}
let g:ale_warn_about_trailing_whitespace = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
" UltiSnips stuff
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsEditSplit="vertical"
let g:ultisnips_python_style = 'google'

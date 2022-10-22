" frees up m to use for my own mappings
noremap mm m
" frees up \ to use for my own mappings in insert mode
inoremap \\ \


" resource config
noremap mso :source $MYVIMRC<CR>
" addtional scroll movements, moving text
noremap <silent> J @="j\<lt>C-E>"<CR>
noremap <silent> K @="k\<lt>C-Y>"<CR>
noremap mj J
noremap mk K
noremap mJ <c-j>
noremap mK <c-k>
" copy to system clipboard
map <silent> Y "+y
" allows multiple pasting of copied text
xnoremap p pgvy
" do not overwrite register with s
nnoremap s "_s
" word completion using tab and shift tab (instead of c-n c-p)
" can still use C-t and C-d to insert/remove tabs from text
inoremap <TAB> <c-n>
inoremap <S-TAB> <c-p>
"" special characters
" checkmark
inoremap \c <c-v>u2705
" crossmark
inoremap \C <c-v>u274c
" word count, and because of conflict with tmux prefix
vnoremap g<c-n> g<C-g>2gs
nnoremap g<c-n> g<C-g>
" clear highlight
nnoremap <Space> :noh<CR>
"" robust jump/search pattern function
function! JumpToPattern(count, visual, pattern, flags)
    if a:visual
        normal! gv
    endif
    for _ in range(a:count)
        call search(a:pattern, a:flags)
    endfor
endfunction
" bufdo e without loss of syntax highlighting and switching buffers
nnoremap me :tabdo windo e<CR>
"" cursor/visual highlight and search
" shortcut to highlight search whole word under cursor
nnoremap <silent> ml :<c-u>let @/ = '\<'.expand('<cword>').'\>'\|set hlsearch<CR>wb
" shortcut to highlight search what's being selected in visual mode (works
" multi line)
function SetSearchVisualSelection()
    let clipboard_original_content=@"
    normal gvy " this overwrites clipboard
    let raw_search=@"
    let @/=substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
    let @"=clipboard_original_content
endfunction
vnoremap ml :call SetSearchVisualSelection()<CR>:set hlsearch<CR>
"" find and replace mappings
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
" find and replace occurences with incrementing counter appended
nnoremap mci :let @a=1 \| %s/search/\='replace'.(@a+setreg('a',@a+1))/g
" delete to black hole register
noremap mx "_x
" split window vertically on new column
nnoremap msb :botr vs<CR>:b 
" git branch sessions
function! MakeSessionGit()
    let git_branch=substitute(system('git branch --show-current'), '\n\+$', '', '')
    silent! execute('!mkdir -p .vim/'.git_branch.'.vim')
    silent! execute('!rm -rf .vim/'.git_branch.'.vim')
    silent! execute "mksession! .vim/".git_branch.".vim"
endfunction
nnoremap mks :<c-u>call MakeSessionGit()<CR>
" recursively load files of type
nnoremap mar :<c-u>args **/*.
" easier reach expand/complete mode
inoremap <c-c> <c-x>
" stop preview window from spawning when using omnicomplete
set completeopt-=preview


"" python file mappings
" block abstraction and execution: make blocks in file and be able to
" immediately send its contents to another tmux window using Slime or
" to clipboard
nnoremap mbl o<CR><CR><CR><ESC>2ki# ---------- [] ----------:<ESC>BBa
nmap <silent> <c-j> :<c-u>call JumpToPattern(v:count1, 0, '\%$\\|^# ----------', '')<cr>zz
xmap <silent> <c-j> :<c-u>call JumpToPattern(v:count1, 1, '\%$\\|^# ----------', '')<cr>zz
nmap <silent> <c-k> :<c-u>call JumpToPattern(v:count1, 0, '\%^\\|^# ----------', 'b')<cr>zz
xmap <silent> <c-k> :<c-u>call JumpToPattern(v:count1, 1, '\%^\\|^# ----------', 'b')<cr>zz
nmap my w<c-k>V<c-j>ygv<Esc>
nmap mY w<c-k>V<c-j>"+ygv<Esc>
" ipdb trace above current line
nnoremap mp Oimport ipdb; ipdb.set_trace()<ESC>:w<CR>
" timeit
xnoremap mvt <ESC>`<Oimport time; my_start_time = time.time()<ESC>`>oprint("my_end_time - my_start_time = ", time.time() - my_start_time)<ESC>


""" settings
"" timeout settings
set timeoutlen=1000 ttimeoutlen=0
"" visual settings
silent! colo koehler
silent! colo darcula
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
" for vim to have consistent colors within tmux
set background=dark
set t_Co=256
au WinLeave * set nocursorline
au WinEnter * set cursorline
set cursorline
highlight CursorLineNR ctermbg=darkgrey
highlight clear CursorLine
"" other settings
set autoread
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
noremap msc :<C-u>SlimeConfig<CR>
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_default_config = {"socket_name": "default", "target_pane": ".0"}
let g:slime_dont_ask_default = 1
xmap <silent> mss <Plug>SlimeRegionSend
nmap <silent> mss w<c-k>V<c-j>:SlimeSend<CR>gv<Esc>
" winresize
let g:winresizer_start_key = 'mw'
" UltiSnips stuff
let g:UltiSnipsExpandTrigger="\\u"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsEditSplit="vertical"
let g:ultisnips_python_style = 'google'
" enunch plugin stuff
nnoremap mRN :Rename 

let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/doc/config
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 README.md
badd +1 alacritty
badd +1 alacritty/alacritty.toml
badd +1 apply_config.sh
badd +1 docker
badd +1 docker/Dockerfile
badd +1 fetch.sh
badd +1 fetch_and_apply_config.sh
badd +1 os
badd +1 os/ubuntu_base.sh
badd +1 os/ubuntu_gnome.sh
badd +1 os/ubuntu_wsl.sh
badd +1 python
badd +1 python/cprofiler.py
badd +1 python/ipython_config.py
badd +1 python/pycodestyle
badd +1 python/python-packages-install.txt
badd +1 sway
badd +1 sway/clamshell.sh
badd +1 sway/config
badd +1 sway/status.sh
badd +1 tmux
badd +1 tmux/tmux.conf
badd +1 treestyletab
badd +1 treestyletab/configs-treestyletab@piro.sakura.ne.jp.json
badd +1 treestyletab/treestyletab.css
badd +1 tridactyl
badd +1 tridactyl/tridactylrc
badd +1 vim
badd +1 vim/VC_session.vim
badd +1 vim/advanced.lua
badd +1 vim/basic.lua
badd +1 vim/nvim-install-update.sh
badd +1 zsh
badd +1 zsh/zshrc
badd +0 ~/.zshrc
argglobal
%argdel
$argadd README.md
$argadd alacritty
$argadd alacritty/alacritty.toml
$argadd apply_config.sh
$argadd docker
$argadd docker/Dockerfile
$argadd fetch.sh
$argadd fetch_and_apply_config.sh
$argadd os
$argadd os/ubuntu_base.sh
$argadd os/ubuntu_gnome.sh
$argadd os/ubuntu_wsl.sh
$argadd python
$argadd python/cprofiler.py
$argadd python/ipython_config.py
$argadd python/pycodestyle
$argadd python/python-packages-install.txt
$argadd sway
$argadd sway/clamshell.sh
$argadd sway/config
$argadd sway/status.sh
$argadd tmux
$argadd tmux/tmux.conf
$argadd treestyletab
$argadd treestyletab/configs-treestyletab@piro.sakura.ne.jp.json
$argadd treestyletab/treestyletab.css
$argadd tridactyl
$argadd tridactyl/tridactylrc
$argadd vim
$argadd vim/VC_session.vim
$argadd vim/advanced.lua
$argadd vim/basic.lua
$argadd vim/nvim-install-update.sh
$argadd zsh
$argadd zsh/zshrc
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit zsh/zshrc
argglobal
if bufexists(fnamemodify("zsh/zshrc", ":p")) | buffer zsh/zshrc | else | edit zsh/zshrc | endif
if &buftype ==# 'terminal'
  silent file zsh/zshrc
endif
balt README.md
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext
edit ~/.zshrc
argglobal
if bufexists(fnamemodify("~/.zshrc", ":p")) | buffer ~/.zshrc | else | edit ~/.zshrc | endif
if &buftype ==# 'terminal'
  silent file ~/.zshrc
endif
balt zsh/zshrc
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext
edit tmux/tmux.conf
argglobal
if bufexists(fnamemodify("tmux/tmux.conf", ":p")) | buffer tmux/tmux.conf | else | edit tmux/tmux.conf | endif
if &buftype ==# 'terminal'
  silent file tmux/tmux.conf
endif
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext
edit vim/basic.lua
argglobal
if bufexists(fnamemodify("vim/basic.lua", ":p")) | buffer vim/basic.lua | else | edit vim/basic.lua | endif
if &buftype ==# 'terminal'
  silent file vim/basic.lua
endif
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext
edit vim/advanced.lua
argglobal
if bufexists(fnamemodify("vim/advanced.lua", ":p")) | buffer vim/advanced.lua | else | edit vim/advanced.lua | endif
if &buftype ==# 'terminal'
  silent file vim/advanced.lua
endif
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :

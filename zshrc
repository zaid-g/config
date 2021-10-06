#. <path>




#vim mode
bindkey -v
export KEYTIMEOUT=1

#for the zoom docker image
export ZOOM_HOME=${HOME}/.zoomus

# Enable colors and change prompt:
autoload -U colors && colors
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
PS1="%B%{$fg[red]%}[%{$fg[red]%}%n%{$fg[red]%}@%{$fg[red]%}%M %{$fg[red]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


## aliases
alias S="sudo"
alias C="clear"
alias RS="source ~/.zshrc"
alias LL="ls -lt"
alias LA="ls -A"
alias L='ls -CF'
alias VM="virt-manager"
alias PO="systemctl poweroff"
# python
alias vipy="python -m IPython"
alias vipy3="python3 -m IPython"
function Pip3(){
    pip3 install wheel
    pip3 install ipdb
    pip3 install neovim
    pip3 install black
    pip3 install flake8
}
function Pyvenv(){
    deactivate
    python3 -m venv $1
    . ./$1/bin/activate
    Pip3
}
alias PT="pytest -sxvv"
alias PTDB="pytest -sxvv --pdb"
# tmux
alias T="tmux"
alias TLS="tmux ls"
alias TAS="tmux attach-session -t"
alias TKS="tmux kill-session -t"
alias TKAs="tmux kill-server"
# vim, VM taken
function Vim(){
    ~/app/nvim.appimage "$@" || nvim "$@" || vim "$@"  
}
alias V="Vim"
alias VS="Vim -S"
alias VU="Vim ~/doc/it/tools/useful-commands.txt.sh"
# git
alias G="git"
alias GS="git status"
alias GD="git diff"
alias GA="git add"
alias GC="git commit"
alias GCM="git commit -m"
alias GCH="git checkout"
alias GM="git merge"
alias GF="git fetch"
alias GL="git log --graph --decorate --oneline"
alias GFO="git fetch origin"
alias GB="git branch --sort=-committerdate"
alias GPUSH="git push -u origin HEAD"
alias GPULL='git pull origin $(git rev-parse --abbrev-ref HEAD)'
# docker
alias D="docker"
alias SD="sudo docker"
alias DB="docker build"
alias SDB="sudo docker build"
alias DR="docker run"
alias SDR="sudo docker run"
alias DC="docker container"
alias SDC="sudo docker container"
alias DCE="docker container exec"
alias SDCE="sudo docker container exec"
alias DI="docker image"
alias SDI="sudo docker image"
# xdg open (open file from terminal with default app)
alias X="xdg-open"



# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

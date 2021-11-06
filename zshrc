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
function CD(){
    current_working_directory=$(pwd)
    dev_or_doc=$(echo "$current_working_directory" | awk -F "/" '{print $4}')
    if [[ "$dev_or_doc" == "dev" ]]; then
        current_proj_directory=$(echo "$current_working_directory" | awk -F "/" '{print $5}')
        mkdir -p ~/doc/projects/$current_proj_directory
        cd ~/doc/projects/$current_proj_directory
    elif [[ "$dev_or_doc" == "doc" ]]; then
        current_proj_directory=$(echo "$current_working_directory" | awk -F "/" '{print $6}')
        mkdir -p ~/dev/$current_proj_directory
        cd ~/dev/$current_proj_directory
    fi
}
alias CDD="cd ~/env/dotfiles"
alias RS="source ~/.zshrc && cd ."
alias LL="ls -lt"
alias LA="ls -A"
alias L='ls -CF'
alias VM="virt-manager"
alias PO="systemctl poweroff"
# python
alias I="python3 -m IPython"
alias P="python3"
function Pip3(){
    pip3 install ipdb
    pip3 install neovim
    pip3 install pyright
    pip3 install pandas
}
function cd() {
    builtin cd $1
    if [[ -d ./.venv ]] ; then
        if [[ -z "$VIRTUAL_ENV" ]] ; then
            . ./.venv/.*/bin/activate
        fi
            deactivate
            . ./.venv/.*/bin/activate
    fi
}
function Pyvenv(){
    project_name="$(basename $PWD)"
    deactivate
    mkdir -p .venv
    builtin cd .venv
    python3 -m venv ".$project_name"
    . ./".$project_name"/bin/activate
    Pip3
    builtin cd ..
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
function VPY(){
    if [[ -z "$1" ]] ; then
        Vim **/*.py
    else
        Vim $1/**/*.py
    fi
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

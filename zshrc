# ---------- [vim mode] ----------:

bindkey -v
export KEYTIMEOUT=1



# ---------- [Enable colors and change prompt] ----------:

autoload -U colors && colors
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
PS1="%B%{$fg[red]%}[%{$fg[red]%}%n%{$fg[red]%}@%{$fg[red]%}%M %{$fg[red]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
zle_highlight=('region:bg=168,fg=251')
zle_highlight=('paste:bg=168,fg=251', 'region:bg=168,fg=251')



# ---------- [auto-completion] ----------:

autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)              # Include hidden files.
zstyle ':completion:*' menu select
bindkey -M menuselect '^[[Z' reverse-menu-complete

# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'


# ---------- [aliases and functions] ----------:

alias S="sudo"
alias C="clear"
alias mv="mv -v"
function MV(){
    latest_download=~/Downloads/$(ls -Art ~/Downloads | tail -n 1)
    mv --backup=t $latest_download .
}
alias CDC="cd ~/doc/projects/config/scripts"
alias CDP="cd ~/doc/projects"
alias CDD="cd ~/Downloads"
function UC(){
    current_working_directory=$(pwd)
    . ~/doc/projects/config/scripts/update.sh
    cd $current_working_directory
}
alias RS="source ~/.zshrc && cd ."
alias ls="ls --color=auto"
alias LL="ls -lt --color=auto"
alias LA="ls -A --color=auto"
alias VM="virt-manager"
alias PO="systemctl poweroff"
# python
alias I="python3 -m IPython"
alias P="python3"
function PIP3(){
    pip3 install wheel
    pip3 install ipdb
    pip3 install neovim
    pip3 install pandas
    pip3 install black
}
function cd() {
    builtin cd $1
    current_working_directory_leaf="$(basename $PWD)"
    if [[ -d ~/.virtualenvs/.$current_working_directory_leaf ]] ; then
        if [[ -z "$VIRTUAL_ENV" ]] ; then
            . ~/.virtualenvs/.$current_working_directory_leaf/bin/activate
        fi
            deactivate
            . ~/.virtualenvs/.$current_working_directory_leaf/bin/activate
    fi
}
function PVENV(){
    current_working_directory=$(pwd)
    project_name="$(basename $PWD)"
    deactivate
    if [ -d ~/.virtualenvs/.$project_name ]; then
        rm -rf ~/.virtualenvs/.$project_name
    fi
    mkdir -p .vim
    mkdir -p ~/.virtualenvs
    builtin cd ~/.virtualenvs
    if [ "$#" -eq 0 ]; then
        python3 -m venv ".$project_name"
    else
        $1 -m venv ".$project_name"
    fi
    . ./".$project_name"/bin/activate
    PIP3
    builtin cd $current_working_directory
    touch requirements.txt
    if ! [ -e .git ]; then
        git init
        wget https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore
        mv Python.gitignore .gitignore
        echo "\n# vim\n.vim\n.ccls*" >> .gitignore
    fi;
}
alias PT="pytest -sxvv"
alias PTDB="pytest -sxvv --pdb"
# find
function FIND(){
    find . -not -path '*/.*' -type f -iname "*${@}*"
}
# grep
function GREP(){
    if [ "$#" -eq 1 ]; then
        grep -rni --exclude-dir='.*' -e $1
    else
        grep -rni --exclude-dir='.*' --include="*.$1" -e $2
    fi
}
# tmux
alias T="tmux -2"
alias TLS="tmux ls"
alias TAS="tmux attach-session -t"
alias TKS="tmux kill-session -t"
alias TKAs="tmux kill-server"
# vim, VM taken
alias V="~/app/neovim/nvim-linux64/bin/nvim"
function VP(){
    patterns=()
    for i in "$@"; do
        patterns+=(**/*.$i)
    done
    V ${patterns[@]}
}
function VS(){
    git_branch=$(git branch --show-current)
    V -S .vim/$git_branch.vim
}
alias VC="V -S ~/doc/projects/config/scripts/VC_session.vim"
alias VN="V -S ~/doc/projects/config/scripts/VN_session.vim"
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
function DOCK(){
    sudo docker run -it -v $HOME/doc/projects/config:/home/ubuntu/doc/projects/config $@ main
}
function DOCKCWD(){
    sudo docker run -it -v $PWD:$PWD -v $HOME/doc/projects/config:/home/ubuntu/doc/projects/config -w $PWD $@ main
}
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
# discord
alias DISCORD="snap run discord"

# ---------- [Syntax highlighting] ----------:

# should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

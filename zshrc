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


alias vipy="python -m IPython"
alias vipy3="python3 -m IPython"
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
alias LL="ls -lt"
alias GPUSH="git push -u origin HEAD"
alias GPULL='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias V="vim"
alias VS="vim -S"
alias T="tmux"
alias TLS="tmux ls"
alias TAS="tmux attach-session -t"
alias TKS="tmux kill-session -t"
alias TKAs="tmux kill-server"
alias VM="virt-manager"
alias PT="pytest -sxvv"
alias PTDB="pytest -sxvv --pdb"


# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

#. <path>




#vim mode
bindkey -v
export KEYTIMEOUT=1

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

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


alias vipy="ipython --TerminalInteractiveShell.editing_mode=vi"
alias vipy3="ipython3 --TerminalInteractiveShell.editing_mode=vi"
alias GS="git status"
alias GD="git diff"
alias GA="git add"
alias GC="git commit -m"
alias GCH="git checkout"
alias GM="git merge"
alias GF="git fetch"
alias GB="git branch --sort=-committerdate"
alias LL="ls -lt"
alias GPO="git push -u origin HEAD"
alias GPU="git pull origin"
alias V="vim"
alias VS="vim -S"
alias T="tmux"
alias TLS="tmux ls"
alias TAS="tmux attach-session -t"
alias TKS="tmux kill-session -t"
alias TKAs="tmux kill-server"


# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

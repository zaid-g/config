#Download base image ubuntu 20.04
FROM ubuntu:20.04

# noninteractive so apt install doesn't break
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update
RUN apt-get update
RUN apt upgrade -y
RUN apt-get upgrade -y


RUN apt-get install git -y
RUN apt install zsh -y
RUN apt install python3 -y
RUN apt install vim -y
RUN apt install python3-pip -y
RUN apt-get install texlive-full -y --fix-missing
RUN apt install ruby-dev ruby-bundler nodejs -y
RUN apt install sudo -y

# user and root pwd
RUN echo 'root:Docker!' | chpasswd

RUN useradd -ms /usr/bin/zsh ubuntu
RUN echo 'ubuntu:Docker!' | chpasswd
RUN adduser ubuntu sudo
USER ubuntu
WORKDIR /home/ubuntu
RUN mkdir env
WORKDIR /home/ubuntu/env
RUN git clone https://github.com/zaid-g/dotfiles.git
WORKDIR /home/ubuntu/env/dotfiles
RUN . ./update.sh
WORKDIR /home/ubuntu/env/dotfiles
RUN . ./vim-nvim-plugins.sh
WORKDIR /home/ubuntu
RUN echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> .zshrc


ENTRYPOINT /usr/bin/zsh

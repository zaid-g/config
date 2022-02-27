#Download base image ubuntu 20.04
FROM ubuntu:20.04

# noninteractive so apt install doesn't break
ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt clean
RUN apt update
RUN apt upgrade -y
RUN apt-get clean
RUN apt-get update
RUN apt-get upgrade -y

# user and root pwd
RUN echo 'root:Docker!' | chpasswd

## locales for utf support
RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# install packages
RUN apt-get install git -y
RUN apt install zsh -y
RUN apt install python3 -y
RUN apt install vim -y
RUN apt install python3-pip -y
RUN apt-get install texlive-full -y --fix-missing
RUN apt install ruby-dev ruby-bundler nodejs -y
RUN apt install sudo -y
RUN apt install python3-venv -y
RUN apt install wget -y
RUN apt install curl -y
RUN apt install golang -y
RUN apt install tmux -y
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt install nodejs -y
RUN npm i -g pyright 
RUN apt install postgresql postgresql-contrib -y

# dummy operation
RUN cd

# postgresql user add
USER postgres
#RUN service postgresql start
#RUN createuser -s ubuntu
#RUN createdb ubuntu

# add ubuntu user and update env
USER root
RUN useradd -ms /usr/bin/zsh ubuntu
RUN echo 'ubuntu:docker' | chpasswd
RUN adduser ubuntu sudo
USER ubuntu
WORKDIR /home/ubuntu
RUN mkdir dev
WORKDIR /home/ubuntu/dev
RUN git clone https://github.com/zaid-g/environment.git
WORKDIR /home/ubuntu/dev/environment
RUN . ./update.sh
WORKDIR /home/ubuntu/dev/environment
RUN . ./vim-nvim-plugins-install-update.sh
WORKDIR /home/ubuntu/dev/environment
RUN bash ./nvim-intall-update.sh
WORKDIR /home/ubuntu/dev/environment
RUN pip3 install -r ./python-packages-install.txt
WORKDIR /home/ubuntu
RUN echo 'PS1="%B%{$fg[green]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[green]%}%~%{$fg[green]%}]%{$reset_color%}$%b "' >> .zshrc

# efm go package
RUN GO111MODULE=on go get github.com/mattn/efm-langserver@latest
RUN echo 'export PATH=$PATH:~/go/bin' >> .zshrc
RUN echo 'cd .' >> .zshrc


ENTRYPOINT ["tmux", "-2"]

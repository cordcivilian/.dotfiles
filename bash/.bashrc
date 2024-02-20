# ~/.bashrc

[[ $- != *i* ]] && return
umask 022

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

shopt -s histappend
shopt -s checkwinsize
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth

export VISUAL="/usr/bin/vim"
export EDITOR="$VISUAL"
export CLICOLOR=1

export PS1='\[\e[01;97m\]\u@\h:\[\e[m\]\[\e[01;92m\]\w\[\e[m\]\[\e[01;97m\]\$\[\e[m\] '

alias ls='ls --color=auto --group-directories-first'

if [[ -f ~/.bashrc_arch13 ]]; then
  source ~/.bashrc_arch13
fi



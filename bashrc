#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
EDITOR="vim" 

#TERM='rxvt-unicode'
#try to  set term for tmux:
TERM='screen-256color'
COLORTERM='rxvt-unicode-256color'


# find running ssh-agent and use it
# info from: http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/
source ~/dotfiles/bin/ssh-find-agent
set_ssh_agent_socket

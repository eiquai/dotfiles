#
# ~/.bashrc
# This file is executed for interactive non-login shells.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#-------------- ALIAS BEGIN----------------
alias tor='~/tor-browser_en-US/start-tor-browser --detach'
alias chromium='setsid /usr/bin/chromium >& /dev/null &'
alias ncmpc='ncmpc -f ~/.ncmpc_config'
alias bopdf='~/Dropbox/BerlinOnline/4_other/bo_pdf/bopdf.sh'
alias emacs='emacs -nw' #start emacs in terminal mode

# make ls use colors automatically
alias ls='ls --color=auto'
#-------------- ALIAS END -----------------

PS1='[\u@\h \W]\$ '

export EDITOR="vim" 

PATH=$PATH:~/dotfiles/bin

export PATH

#TERM='rxvt-unicode-256color'
#try to  set term for tmux:
#TERM='screen-256color'
COLORTERM='rxvt-unicode-256color'


# find running ssh-agent and use it
# info from: http://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/
#source ~/dotfiles/bin/ssh-find-agent
#set_ssh_agent_socket

## GPG-Agent for SSH
##
## Currently this is not working - for this reason, I will use standard ssh-agent until i figure out a solution for this problem:
# see bash_profile

## Start gpg-agent if not already running
#if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
#    gpg-connect-agent /bye >/dev/null 2>&1
#fi
#
#unset SSH_AGENT_PID
#if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
#    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
#fi
#
## Set GPG TTY
#export GPG_TTY=$(tty)
#
## Refresh gpg-agent tty in case user switches to X
## not working for t400 and t420s because here we use gdm
#gpg-connect-agent updatestartuptty /bye >/dev/null

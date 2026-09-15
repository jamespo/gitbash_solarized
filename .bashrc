#!/bin/bash
# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# Source global definitions
if [[ -f /etc/bashrc ]]; then
        . /etc/bashrc
fi

export SHELL=/bin/bash
export TERM=xterm

function get_hostname {
  export SHORTNAME=${HOSTNAME%%.*}
}

function git_branch() { 
  gitbranch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'); 
}

function user_color {
  id | grep "root" > /dev/null
  RETVAL=$?
  if [[ $RETVAL == 0 ]]; then
    usercolor="[0;31m";
  else
    usercolor="[0;32m";
  fi
}

function settitle() {
  u=${USER}
  h="$u@${HOSTNAME}"
  echo -ne "\e]2;$h\a\e]1;$h\a";
}

# Set directory colors
eval "$(dircolors ~/.dir_colors)"


truncate_pwd() {
  local max_len=25
  local dir="${PWD/#$HOME/~}" # Replace $HOME with ~

  if [ ${#dir} -gt $max_len ]; then
    # Keep leading ellipsis + the last (max_len - 3) characters
    TRUNC_PWD="...${dir: -$((max_len - 3))}"
  else
    TRUNC_PWD="$dir"
  fi
}

PROMPT_COMMAND=truncate_pwd
export PS1='\u@\h:${TRUNC_PWD}\$ '

# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[0;34m'
host_name='[1;31m'
branchcolor='[0;36m'
user_color
#PROMPT_COMMAND='settitle; git_branch; get_hostname; history -a;'
PROMPT_DIRTRIM=2
# git branch version
#PS1='\n\[\e${cwdcolor}\][${PWD}]\[\e${branchcolor}\]${gitbranch}\n\[\e${usercolor}\][\u]\[\e${host_name}\][${SHORTNAME}]\[\e${inputcolor}\] $ '
# no git branch
#PS1='\[\e${usercolor}\][\u]\[\e${host_name}\][\h]\e${cwdcolor}[\w]\[\e${inputcolor}\]$ '
# truncated for long dirs
PS1='\[\e${usercolor}\][\u]\[\e${host_name}\][\h]\e${cwdcolor}[${TRUNC_PWD}\]\[\e${inputcolor}\]$ '


# Aliases
alias ls='ls --color'
alias grep='grep -n --color'

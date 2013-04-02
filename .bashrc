# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Do not add duplicate history entry.
HISTCONTROL=erasedups:ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Get current branch name.
function parse_git_branch {
git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set a fancy prompt, and add git branch name to it.
PS1='\[\e[01;30m\]________________________________________________________________________________\n\[\e[01;34m\][\w]$(parse_git_branch)\n\[\e[01;32m\]\u@\h\[\e[00m\]\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
   PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
   ;;
*)
   ;;
esac

# enable bash completion in interactive shells.
if ! shopt -oq posix; then
 if [ -f /usr/share/bash-completion/bash_completion ]; then
   . /usr/share/bash-completion/bash_completion
 elif [ -f /etc/bash_completion ]; then
   . /etc/bash_completion
 fi
fi

# Make the terminal colorful.
TERM=xterm-256color

# My aliases
function u () {
    cd "$@" && ls --color -F
}

alias aptitude='sudo aptitude'
alias df='df -h'
alias du='du -h'
alias em='emacsclient -c -a emacs'
alias g++='g++ -Wall -pedantic'
alias gcc='gcc -Wall -pedantic'
alias gg='clear && git status'
alias h='ls --color -F'
alias ha='ls --color -lhA'
alias hh='ls --color -lhF'
alias rm='rm -i'

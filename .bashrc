# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# http://unix.stackexchange.com/a/4973
add_to_PATH () {
    for d; do
        case ":$PATH:" in
            *":$d:"*) :;;
            *) PATH=$PATH:$d;;
        esac
    done
}

# Add ~/bin to PATH
add_to_PATH $HOME/bin

# The maximum number of lines contained in the history file.
export HISTFILESIZE=20000

# The number of commands to remember in the command  history
export HISTSIZE=10000

# Do not add duplicate history entry.
export HISTCONTROL=erasedups:ignoredups

# If set, the history list is appended to the file named by the value
# of the HISTFILE variable when the shell exits, rather than
# overwriting the file.
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Get the current git branch name.
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

# Enable bash completion in interactive shells.
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -n "$(type -p brew)" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# Make the terminal colorful.
export TERM=xterm-256color

# Let ls shows colors
if [ "$(uname)" == "Darwin" ]; then
    alias h='ls -GF'
else
    alias h='ls --color=auto -F'
fi

# My aliases
alias aptitude='sudo aptitude'
alias df='df -h'
alias du='du -h'
alias ec='emacsclient -c -a emacs'
alias g++='g++ -Wall -pedantic'
alias gcc='gcc -Wall -pedantic'
alias gg='clear && git status'
alias ha='h -hlA'
alias hh='h -hlF'
alias rm='rm -i'
alias u='cd'

# Source my private bash script
if [ -f ~/.bashrc_private ]; then
   . ~/.bashrc_private
fi

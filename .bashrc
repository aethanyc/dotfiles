# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# http://unix.stackexchange.com/a/4973
add_path () {
    for d; do
        case ":$PATH:" in
            *":$d:"*) :;;
            *) PATH=:$d:$PATH;;
        esac
    done
}

# Add ~/bin to PATH
add_path $HOME/bin

# Pretty print path
function print_path () {
    echo $PATH | tr ':' '\n' | awk '{print "["NR"]"$0}'
}

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
function parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Set a fancy prompt.
function prompt_command () {
    # Reference:
    # https://makandracards.com/makandra/1090-customize-your-bash-prompt
    # http://stackoverflow.com/q/103857
    EXITSTATUS="$?"
    LINE="`eval printf "%.s_" {1..$COLUMNS}`"

    OFF="\[\e[0m\]"
    BOLD="\[\e[1m\]"
    BLACK="\[\e[30m\]"
    RED="\[\e[31m\]"
    GREEN="\[\e[32m\]"
    YELLOW="\[\e[33m\]"
    MAGENTA="\[\e[34m\]"
    BLUE="\[\e[35m\]"
    CYAN="\[\e[36m\]"
    WHITE="\[\e[37m\]"

    # Print a line to separate the previous command.
    PS1="${LINE}\n"

    # Print user name, host name, working directory, and git branch name.
    PS1+="${BOLD}${MAGENTA}\u@\h: ${BLUE}\w${GREEN}`parse_git_branch`\n"

    # If the last command is success, print a green 'V'. Otherwise, print a red 'X'.
    if [ "${EXITSTATUS}" = 0 ]; then
        PS1+="${GREEN}V "
    else
        PS1+="${RED}X "
    fi

    # Finally, reset the face, and print a prompt sign.
    PS1+="${OFF}\$ "
}

PROMPT_COMMAND=prompt_command

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

# Make the terminal more colorful.
if [ "$TERM" = "xterm" ]; then
    TERM=xterm-256color
fi

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
alias ha='h -hlA'
alias hh='h -hlF'
alias rm='rm -i'
alias u='cd'


# Git aliases
alias ga='git add'
alias gbr='git branch -v'
alias gbrm='git branch -m'
alias gca='git commit --amend'
alias gcp='git cherry-pick'
alias gci='git commit'
alias gco='git checkout'
alias gdi='git difftool'
alias gfe='git fetch'
alias ghd='git log -1 --stat'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gpu='git pull'
alias grh='git reset HEAD~'
alias grhh='git reset --hard HEAD~'
alias gst='git status'
alias gsu='git submodule update --init'
alias gus='git reset' # g'us' stands for unstage


# Source my private bash script
if [ -f ~/.bashrc_private ]; then
   . ~/.bashrc_private
fi

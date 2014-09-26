# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# http://unix.stackexchange.com/a/4973
add_path () {
    for d; do
        case ":$PATH:" in
            *":$d:"*) :;;
            *) PATH=$d:$PATH;;
        esac
    done
}

# Add ~/bin to PATH
add_path $HOME/bin

# Pretty print path
print_path () {
    echo $PATH | tr ':' '\n' | awk '{print "["NR"]"$0}'
}

# The maximum number of lines contained in the history file.
export HISTFILESIZE=20000

# The number of commands to remember in the command  history
export HISTSIZE=10000

# Do not add duplicate history entry.
export HISTCONTROL=erasedups:ignoredups

# Set a default editor
export EDITOR=emacs

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
parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Setup to use __git_ps1.
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
if [ -f ~/.git-prompt.sh ]; then
    . ~/.git-prompt.sh
elif [ -n "$(type -p brew)" ] &&\
         [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
    . $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
fi

if [ -n "$(declare -F __git_ps1)" ]; then
    export GIT_PS1_SHOWUPSTREAM="verbose name"
fi

# Set a fancy prompt.
prompt_command () {
    # Reference:
    # https://makandracards.com/makandra/1090-customize-your-bash-prompt
    # http://stackoverflow.com/q/103857
    EXITSTATUS="$?"
    LINE="$(eval printf "%.s_" {1..$COLUMNS})"

    OFF="\[\e[0m\]"
    BOLD="\[\e[1m\]"
    BLACK="\[\e[30m\]"
    RED="\[\e[31m\]"
    GREEN="\[\e[32m\]"
    YELLOW="\[\e[33m\]"
    BLUE="\[\e[34m\]"
    MAGENTA="\[\e[35m\]"
    CYAN="\[\e[36m\]"
    WHITE="\[\e[37m\]"

    # Print a line to separate the previous command.
    PS1="${LINE}\n"

    # Print user name, host name, working directory.
    PS1+="${BOLD}${BLUE}\u@\h: ${MAGENTA}\w"

    # Print git branch name by __git_ps1 if available.
    if [ -n "$(declare -F __git_ps1)" ]; then
        PS1+="${GREEN}$(__git_ps1)"
    else
        PS1+="${GREEN}$(parse_git_branch)"
    fi

    # Append current Python's virtualenv name.
    if [ "${VIRTUAL_ENV}" ]; then
        PS1+=" ${GREEN}($(basename ${VIRTUAL_ENV}))"
    fi

    PS1+="\n"

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
    elif [ -n $"(type -p brew)" ] && [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# Make the terminal more colorful.
if [ "$TERM" == "xterm" ]; then
    TERM=xterm-256color
fi

# Let ls shows colors
if [ "$(uname)" == "Darwin" ]; then
    alias h='ls -GF'
else
    alias h='ls --color=auto -F'
fi

# Use autojump if it's available.
if [ -s ~/.autojump/etc/profile.d/autojump.sh ]; then
    . ~/.autojump/etc/profile.d/autojump.sh
elif [ -n "$(type -p brew)" ] && [ -s $(brew --prefix)/etc/autojump.sh ]; then
    . $(brew --prefix)/etc/autojump.sh
fi

# Toggle hidden files shown/hidden on Mac OS X
if [ "$(uname)" == "Darwin" ]; then
    toggle_hidden() {
        if [ "$(defaults read com.apple.finder AppleShowAllFiles)" == "TRUE" ]; then
            echo "Hidden files have been hidden."
            defaults write com.apple.finder AppleShowAllFiles FALSE
        else
            echo "Hidden files have been shown."
            defaults write com.apple.finder AppleShowAllFiles TRUE
        fi
        killall Finder
    }
fi

# My aliases
alias aptitude='sudo aptitude'
alias clang='clang -Wall -pedantic'
alias clang++='clang++ -Wall -pedantic'
alias df='df -h'
alias du='du -h'
alias ec='emacsclient -c -a emacs'
alias g++='g++ -Wall -pedantic'
alias gcc='gcc -Wall -pedantic'
alias grep='grep --color=auto'
alias ha='h -hlA'
alias hh='h -hlF'
alias rm='rm -i'
alias u='cd'


# Git aliases
alias ga='git add'
alias gbk='git reset HEAD~'     # g'bk' stands for back
alias gbkh='git reset --hard HEAD~'
alias gbr='git branch -v'
alias gbrm='git branch -m'
alias gca='git commit --amend'
alias gci='git commit'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gdd='git difftool -d'
alias gdi='git difftool'
alias gfe='git fetch'
alias ghd='git log -1 --stat'
alias glg='git log --graph --date-order --pretty=format:"%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gla='glg --all'
alias gpu='git pull'
alias grhh='git reset --hard HEAD'
alias gst='git status'
alias gsu='git submodule update --init'
alias gsur='git submodule update --init --recursive'
alias gus='git reset'           # g'us' stands for unstage

# Git alias completion
if [ "$(declare -F __git_complete)" ]; then
    __git_complete ga _git_add
    __git_complete gbr _git_branch
    __git_complete gbrm _git_branch
    __git_complete gca _git_commit
    __git_complete gci _git_commit
    __git_complete gco _git_checkout
    __git_complete gcp _git_cherry_pick
    __git_complete gdd _git_difftool
    __git_complete gdi _git_difftool
    __git_complete gfe _git_fetch
    __git_complete glg _git_log
    __git_complete gla _git_log
    __git_complete gpu _git_pull
    __git_complete gus _git_reset
fi


# Source my private bash script
if [ -f ~/.bashrc_private ]; then
    . ~/.bashrc_private
fi

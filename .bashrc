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

# Pretty print path
print_path () {
    echo $PATH | tr ':' '\n' | awk '{print "["NR"]"$0}'
}

# https://stackoverflow.com/a/10737906
include () {
    [[ -f "$1" ]] && source "$1"
}

add_path $HOME/bin
add_path $HOME/.cargo/bin

if [ "$(uname)" == "Darwin" ]; then
    # Homebrew's install path, defaults to /usr/local.
    export HOMEBREW_PATH=$(brew --prefix)

    # Link Apps installed by `brew cask` to /Applications
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"

    # Toggle hidden files shown/hidden on Mac OS X
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

# Emacs Settings
if [ "$(uname)" == "Darwin" ]; then
    # Need makeinfo to build Emacs.
    # brew install texinfo
    add_path /usr/local/opt/texinfo/bin

    # Use Emacs in Emacs.app.
    add_path /Applications/Emacs.app/Contents/MacOS
    add_path /Applications/Emacs.app/Contents/MacOS/bin
else
    add_path ~/Projects/emacs/src
    add_path ~/Projects/emacs/lib-src
fi

# The maximum number of lines contained in the history file.
export HISTFILESIZE=20000

# The number of commands to remember in the command  history
export HISTSIZE=10000

# Ignore lines matching previous history and lines which begins with a
# space. `man bash` for details.
export HISTCONTROL=ignoreboth:erasedups

# Set a default editor
export EDITOR="emacsclient -c -a emacs "

# Tell GLOBAL to treat *.h files as a C++ source file
export GTAGSFORCECPP=1

# If set, the history list is appended to the file named by the value
# of the HISTFILE variable when the shell exits, rather than
# overwriting the file.
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Free Ctrl-s and Ctrl-q on terminal.
stty -ixon -ixoff

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Setup to use __git_ps1 on macOS. Linux should have it loaded
# automatically.
include $HOMEBREW_PATH/etc/bash_completion.d/git-prompt.sh

# Show the current branch status comparing to the upstream.
export GIT_PS1_SHOWUPSTREAM="verbose name"

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

    # Append current mozconfig's name if in gecko.
    if [ -n "$(type -p mozconfig)" ] && [[ "$(basename $(pwd))" =~ "gecko" ]]; then
        PS1+=" ${GREEN}($(basename $(mozconfig)))"
    fi

    # Print git branch name by __git_ps1 if available.
    if [ -n "$(declare -F __git_ps1)" ]; then
        PS1+="${GREEN}$(__git_ps1)"
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
include $HOMEBREW_PATH/etc/bash_completion

# Use autojump if it's available.
include /usr/share/autojump/autojump.sh
include $HOMEBREW_PATH/etc/autojump.sh

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

# Settings for Mozilla development.
if [ "$(uname)" == "Darwin" ]; then
    add_path ~/.mozbuild/android-sdk-macosx/platform-tools
    add_path ~/.mozbuild/android-sdk-macosx/tools
else
    add_path ~/.mozbuild/android-sdk-linux/platform-tools
    add_path ~/.mozbuild/android-sdk-linux/tools
fi
add_path ~/.mozbuild/git-cinnabar
add_path ~/Projects/moz-git-tools

include ~/Projects/gecko/python/mach/bash-completion.sh

# Install via `pip install mozconfigwrapper`
include "$(type -p mozconfigwrapper.sh)"

# Mach alias for gecko.
alias mb='./mach build'
alias mbb='./mach build binaries'
alias mbdb='./mach build-backend -b CompileDB'
alias mbf='./mach build faster'
alias mcf='./mach clang-format'
alias md='./mach package && ./mach install && ./mach run'
alias mr='./mach run'
alias mrl='./mach run --layoutdebug'
alias mrlrr='./mach run --layoutdebug --debugger=rr --debugger-args=-M'

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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases
alias ga='git add'
alias gbk='git reset HEAD~'     # g'bk' stands for back
alias gbkh='git reset --hard HEAD~'
alias gbr='git branch -v'
alias gbrm='git branch -m'
alias gbru='git branch -u origin/master'
alias gca='git commit --amend'
alias gci='git commit'
alias gco='git checkout'
alias gcom='git checkout -B master origin/master'
alias gcp='git cherry-pick'
alias gdd='git difftool -d'
alias gdi='git difftool'
alias gfe='git fetch'
alias ghd='git log -1 --stat'
alias glg='git log --graph --date-order --pretty=format:"%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gla='glg --all'
alias gpu='git pull'
alias grhh='git reset --hard HEAD'
alias gru='git remote update'
alias gst='git status'
alias gsu='git submodule update --init'
alias gsur='git submodule update --init --recursive'
alias gus='git reset'           # g'us' stands for unstage

# Hg alias
alias hlg='hg log -G'

# Git alias completion for Linux. macOS should have it loaded automatically.
include /usr/share/bash-completion/completions/git
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
include ~/.bashrc_private

## Util functions

# Add a path to PATH.
# http://unix.stackexchange.com/a/4973
add_path () {
    for d; do
        case ":$PATH:" in
            *":$d:"*) :;;
            *) PATH=$d:$PATH;;
        esac
    done
}

# Pretty print PATH
print_path () {
    echo $PATH | tr ':' '\n' | awk '{print "["NR"]"$0}'
}

# https://stackoverflow.com/a/10737906
include () {
    [[ -f "$1" ]] && source "$1"
}

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(autojump git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='emacsclient -c -a emacs'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Emacs Settings
if [[ "$(uname)" == "Darwin" ]]
then
    # Use Emacs in Emacs.app.
    add_path /Applications/Emacs.app/Contents/MacOS
    add_path /Applications/Emacs.app/Contents/MacOS/bin
else
    add_path ~/Projects/emacs/src
    add_path ~/Projects/emacs/lib-src
fi

# Homebrew setting
eval "$(/opt/homebrew/bin/brew shellenv)"

## Mozilla development

# Export user-wide python packages installations.
# https://firefox-source-docs.mozilla.org/setup/macos_build.html#install-mercurial
add_path "$(python3 -m site --user-base)/bin"

# Install via `pip3 install mozconfigwrapper`
include "$(which mozconfigwrapper.sh)"

add_path ~/.mozbuild/git-cinnabar

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias u="cd"
alias df='df -h'
alias du='du -h'
alias ec='emacsclient -c -a emacs'
alias h='ls'
alias ha='ls -hlA'
alias hh='ls -hlF'
alias rm='rm -i'
alias rp='rr replay -p'
function rpg() {
    rr replay -p "$1" -g "$2"
}

# Mozilla development aliases
alias mb='./mach build'
alias mbb='./mach build binaries'
alias mbdb='./mach build-backend -b CompileDB'
alias mbf='./mach build faster'
alias mcf='./mach clang-format'
alias md='./mach package && ./mach install && ./mach run'
alias mp='moz-phab'
alias ms='moz-phab submit --no-wip'
alias mr='./mach run'
alias mrrr='./mach run --debugger=rr --debugger-args=-M'
alias mrl='./mach run --layoutdebug'
alias mrlrr='./mach run --layoutdebug --debugger=rr --debugger-args=-M'

# Git aliases
alias ga='git add'
alias gbk='git reset HEAD~'     # g'bk' stands for back
alias gbkh='git reset --hard HEAD~'
alias gbr='git branch -v --sort=committerdate'
alias gbrm='git branch -m'
alias gbru='git branch -u origin/master || git branch -u origin/main'
alias gca='git commit --amend'
alias gci='git commit'
alias gco='git checkout'
alias gcom='git checkout -B master origin/master || git checkout -B main origin/main'
alias gcp='git cherry-pick'
alias gdd='git difftool -d'
alias gdi='git difftool'
alias gfe='git fetch'
alias ghd='git log -1 --stat'
alias glg='git log --graph --date-order --pretty=format:"%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --date=relative'
alias gla='glg --all'
alias gpfa='git push -f aethanyc'
alias gpu='git pull'
alias grhh='git reset --hard HEAD'
alias gru='git remote update'
alias gst='git status'
alias gsu='git submodule update --init'
alias gsur='git submodule update --init --recursive'
alias gus='git reset'           # g'us' stands for unstage
alias gwip='glg origin/master..'

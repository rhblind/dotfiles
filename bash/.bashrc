# ~/.bashrc: executed by bash(1) for non-login shells

# if not running interactively, dont't do anything
[ -z "$PS1" ] && return

# timezone info
export TZ="Europe/Oslo"

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If running Darwin
if [ `uname -s` == "Darwin" ]; then
    # brew bash completion
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi

    # some custom exports
    export PATH="~/.bin:/usr/local/bin:/usr/local/sbin:$PATH" # make brew installed files take predecence over OS X defaults
    export LANG=no_NO.UTF-8
    export LC_ALL=no_NO.UTF-8
    export CLICOLOR=1	# enable ls colors

fi
# Python
test -d $HOME/.poetry/bin/ && export PATH="$HOME/.poetry/bin:$PATH"

# Elixir
test -d $HOME/.local/opt/elixir-ls && export ELS_INSTALL_PREFIX="$HOME/.local/opt/elixir-ls"

# Emacs
export DOOMDIR=$HOME/.doom.d
test -d $HOME/.emacs.d-doom/bin && export PATH="$HOME/.emacs.d-doom/bin:$PATH"

export SPACEMACSDIR=$HOME/.spacemacs.d
test -d $HOME/.emacs.d-spacemacs/bin && export PATH="$HOME/.emacs.d-spacemacs/bin:$PATH"

if [ -f "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
    export EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    alias emacs="$EMACS -nw"
fi
if [ -f "/Applications/Emacs.app/Contents/MacOS/bin/emacsclient" ]; then
    alias emacsclient="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
fi

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t -a emacs -nw"     # $EDITOR should open in terminal
export VISUAL="emacsclient -c -a emacs -n"      # $VISUAL opens in GUI with non-daemon as alternate

# GPG Magic
export SSH_AUTH_SOCK="$(/usr/local/MacGPG2/bin/gpgconf --list-dirs agent-ssh-socket)"
export GPG_AGENT_INFO="$(/usr/local/MacGPG2/bin/gpgconf --list-dirs agent-socket):$(pgrep gpg-agent):1"

#
# Aliases
#
alias grep="grep --color=auto" 2>/dev/null
alias egrep="egrep --color=auto" 2>/dev/null
alias fgrep="fgrep --color=auto" 2>/dev/null
alias sl="ls" 2>/dev/null
alias ll="ls -l" 2>/dev/null
alias la="ls -A" 2>/dev/null
alias l="ls -CF" 2>/dev/null
alias cls="clear" 2>/dev/null
alias cp="cp -v" 2>/dev/null
alias mv="mv -v" 2>/dev/null
alias tm="tmux" 2>/dev/null
alias td="tmux detach" 2>/dev/null
alias gs="git status --short" 2>/dev/null
alias vim="vi -v" 2>/dev/null
alias pe="pipenv" 2>/dev/null
alias mx=$VISUAL 2>/dev/null
alias e=$EDITOR 2>/dev/null

#
# User configuration
#
export SSH_KEY_PATH="~/.ssh/rsa_id"     # Default ssh key
. "$HOME/.cargo/env"

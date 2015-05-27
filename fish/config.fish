#
# Fish shell configuration
#

set EDITOR "vim"                                # Default editor
set PROJECT_HOME $HOME/Documents/workspace/     # Virtualfish PROJECT_HOME
set fish_greeting ""                            # I don't need a greeting
#set fish_custom $HOME/dotfiles/oh-my-fish
set fish_path $HOME/.oh-my-fish
set fish_theme bobthefish
set fish_plugins theme android-sdk osx git-flow ssh vundle brew python django node virtualfish

. $fish_path/oh-my-fish.fish                    # Load the oh-my-fish configuration

#
# Exports
#
set -x fish_user_paths $fish_user_paths /usr/local/bin
set -x LANG "no_NO.UTF-8"
set -x LC_ALL "no_NO.UTF-8"

#
# Aliases
#
alias grep "grep --color=auto"
alias egrep "egrep --color=auto"
alias fgrep "fgrep --color=auto"
alias sl "ls"
alias cp "cp -v"
alias mv "mv -v"
alias ws "cd $PROJECT_HOME"

#
# Python 
#
eval (python -m virtualfish compat_aliases)     # Load virtualfish

#
# Android stuff
#
set ANDROID_SDK_ROOT $HOME/Library/Android/sdk

#
# Custom key bindings
#
function fish_user_key_bindings
    bind    \e\[1\;9C   forward-word
    bind    \e\[1\;9D   backward-word
    bind    \e\[dw      backward-kill-word
end

#
# Functions
#

# Start MacVim with vim command
function vim
    mvim -fg $argv &
end


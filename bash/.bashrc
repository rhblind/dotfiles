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

# see https://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash
# for a list of valid color codes
if [[ $TERM =~ screen ]]; then
    PS1='\[\033[33m\]\u@$STY\[\033[00m\]:\[\033[0m\]\w\[\033[00m\]\$ '
else
    PS1='\[\033[33m\]\u@\h\[\033[00m\]:\[\033[0m\]\w\[\033[00m\]\$ '
fi


# If running Darwin
if [ `uname -s` == "Darwin" ]; then
    # brew bash completion
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi

    # some custom exports
    export ARCHFLAGS="-arch x86_64"
    export PATH="~/.bin:/usr/local/bin:/usr/local/sbin:$PATH" # make brew installed files take predecence over OS X defaults
    export LANG=no_NO.UTF-8
    export LC_ALL=no_NO.UTF-8
    export CLICOLOR=1	# enable ls colors

    # Set Android ENV variables
    export ANDROID_HOME="$HOME/Library/Android/sdk"
    export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$ANDROID_HOME/bin:$PATH

    # Set Java HOME
    # export JAVA_HOME="/Library/Java/Home"                                               # Java 6
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home"  # Java 7
    # export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home"  # Java 8

    # Scala HOME for use with IntelliJ
    export SCALA_HOME="/usr/local/opt/scala/idea"

    # Scala sbt (simple build tool) options
    if [ "X$(which sbt)" != "X" ]; then
        export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
    fi

    if [ "X$(which go)" != "X" ]; then
        export PATH=$PATH:/usr/local/opt/go/libexec/bin
    fi

    # Add homebrew node.js to path if exists
    NODE=$(which node)
    if [ "X$NODE" != "X" ]; then
        # Source the npm bash completion for current node version
        NODE_VER=`$NODE -v`
        NODE_INSTALL_DIR="/usr/local/Cellar/node/${NODE_VER//[^.0-9]/}"
        if [ -d $NODE_INSTALL_DIR ]; then
            . $NODE_INSTALL_DIR/libexec/npm/lib/node_modules/npm/lib/utils/completion.sh
        fi

        # Global npm binaries are installed here
        if [ -d /usr/local/share/npm/bin ]; then
            export PATH=$PATH:/usr/local/share/npm/bin
        fi
    fi

    # Vagrant stuff
    export VAGRANT_HOME="~/.vagrant.d"

fi

# If running Linux
if [ `uname -s` == "Linux" ]; then
    # enable bash completion
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

    # some linux-only aliases
    alias ls="ls --color=auto"
fi

# Load AWS access keys if existing
if [[ -e ~/.ec2/access_key && -r ~/.ec2/access_key ]]; then
    export AWS_CONFIG_FILE="~/.ec2/access_key"
fi

# See if screen is installed, and list all sockets if any
SCREEN=$(which screen)
if [ "X$SCREEN" != "X" ]; then
    $(echo $SCREEN -ls)
fi

# If sublime is installed, override previous EDITOR
SUBLIME=$(which subl)
if [ "X$SUBLIME" != "X" ]; then
    export EDITOR="$SUBLIME -w"
fi

# If MacVim is installed, override previous EDITOR
if [ "X$(which mvim)" != "X" ]; then
    export EDITOR="$(which mvim) -f"
fi

### Visual Studio Code ###
code () {
    if [[ $# = 0 ]]
    then
        open -a "Visual Studio Code"
    else
        [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
        open -a "Visual Studio Code" --args "$F"
    fi
}

### pip bash completion ###
_pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

### Django bash completion ###
_django_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
	               DJANGO_AUTO_COMPLETE=1 $1 ) )
}
complete -F _django_completion -o default django-admin.py manage.py django-admin

_python_django_completion()
{
    if [[ ${COMP_CWORD} -ge 2 ]]; then
        PYTHON_EXE=$( basename -- ${COMP_WORDS[0]} )
        echo $PYTHON_EXE | egrep "python([2-9]\.[0-9])?" >/dev/null 2>&1
        if [[ $? == 0 ]]; then
            PYTHON_SCRIPT=$( basename -- ${COMP_WORDS[1]} )
            echo $PYTHON_SCRIPT | egrep "manage\.py|django-admin(\.py)?" >/dev/null 2>&1
            if [[ $? == 0 ]]; then
                COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]:1}" \
                               COMP_CWORD=$(( COMP_CWORD-1 )) \
                               DJANGO_AUTO_COMPLETE=1 ${COMP_WORDS[*]} ) )
            fi
        fi
    fi
}

# Support for multiple interpreters.
unset pythons
if command -v whereis &>/dev/null; then
    python_interpreters=$(whereis python | cut -d " " -f 2-)
    for python in $python_interpreters; do
        pythons="${pythons} $(basename -- $python)"
    done
    pythons=$(echo $pythons | tr " " "\n" | sort -u | tr "\n" " ")
else
    pythons=python
fi
complete -F _python_django_completion -o default $pythons

### End Django bash completion ###

### AWS CLI completion ###
AWS_COMPLETER=$(which aws_completer)
if [ "X$AWS_COMPLETER" != "X" ]; then
  complete -C "$AWS_COMPLETER" aws
fi

# virtualenvwrapper
VIRTUALENVWRAPPER=$(which virtualenvwrapper.sh)
if [ "X$VIRTUALENVWRAPPER" != "X" ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    . $VIRTUALENVWRAPPER

    PYTHON3=$(which python3)
    if [ "X$PYTHON3" != "X" ]; then
        alias mkvirtualenv3='mkvirtualenv --python=`echo $(which python3)`'
    fi
fi

# some aliases
alias grep="grep --color=auto" 2>/dev/null
alias egrep="egrep --color=auto" 2>/dev/null
alias fgrep="fgrep --color=auto" 2>/dev/null
alias sl="ls" 2>/dev/null
alias ll="ls -l" 2>/dev/null
alias la="ls -A" 2>/dev/null
alias l="ls -CF" 2>/dev/null
#alias cp="cp -v" 2>/dev/null
alias mv="mv -v" 2>/dev/null
alias vim="mvim -fg" 2>/dev/null

# rvm (Ruby Virtual Manager)
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
eval "$(rbenv init -)"

# added by travis gem
[ -f /Users/rolf/.travis/travis.sh ] && source /Users/rolf/.travis/travis.sh

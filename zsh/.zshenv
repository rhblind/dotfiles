#
# oh-my-zsh settings
#
export ZSH=/Users/rolf/.oh-my-zsh       # Path to your oh-my-zsh installation.
CASE_SENSITIVE="true"                   # Uncomment the following line to use case-sensitive completion.

#
# User configuration
#
export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/rolf/.rbenv/shims:/Users/rolf/Library/Android/sdk/platform-tools:/Users/rolf/Library/Android/sdk/tools:/Users/rolf/Library/Android/sdk/bin:~/.bin:/usr/local/sbin:/usr/local/opt/go/libexec/bin:/Users/rolf/.rvm/bin"
export SSH_KEY_PATH="~/.ssh/rsa_id"     # Default ssh key
export LANG=no_NO.UTF-8                 # Language settings
export LC_ALL=no_NO.UTF-8               # Language settings

# Java
export JAVA_HOME="/Library/Java/Home"

# Scala
export SCALA_HOME="/usr/local/opt/scala/idea"
if [ "X$(which sbt)" != "X" ]; then
    export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
fi

# Android stuff
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Node stuff
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Z
source $(brew --prefix z)/etc/profile.d/z.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

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
alias gs="git status" 2>/dev/null

#
# Functions
#

function docker-cleanup {
  #
  # Use `docker-cleanup --dry-run` to see what would
  # be deleted.
  #
  EXITED=$(docker ps -q -f status=exited)
  DANGLING=$(docker images -q -f "dangling=true")

  if [ "$1" == "--dry-run" ]; then
    echo "==> Would stop containers:"
    echo $EXITED
    echo "==> And images:"
    echo $DANGLING
  else
    if [ -n "$EXITED" ]; then
      docker rm $EXITED
    else
      echo "No containers to remove."
    fi
    if [ -n "$DANGLING" ]; then
      docker rmi $DANGLING
    else
      echo "No images to remove."
    fi
  fi
}

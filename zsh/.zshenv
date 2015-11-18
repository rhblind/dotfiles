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

# Android stuff
export ANDROID_HOME="$HOME/Library/Android/sdk"

# Node stuff
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='subl'
fi

# export aws key and id
#AWS_CREDENTIALS_FILE=~/.aws/credentials
#if [ -r $AWS_CREDENTIALS_FILE ]; then
#    DEFAULT_AWS_ACCESS_KEY_ID=`awk -F'= ' '/^\[default/ {x=1; next} /^\[/ {x=0} x==1 && /^\aws_access_key_id/ {print $2}' $AWS_CREDENTIALS_FILE`
#    DEFAULT_AWS_SECRET_ACCESS_KEY=`awk -F'= ' '/^\[default/ {x=1; next} /^\[/ {x=0} x==1 && /^\aws_secret_access_key/ {print $2}' $AWS_CREDENTIALS_FILE`
#    if [[ "${DEFAULT_AWS_ACCESS_KEY_ID+x}" && "${DEFAULT_AWS_SECRET_ACCESS_KEY+x}" ]]; then
#        export AWS_ACCESS_KEY_ID=$DEFAULT_AWS_ACCESS_KEY_ID
#        export AWS_SECRET_ACCESS_KEY=$DEFAULT_AWS_SECRET_ACCESS_KEY
#    fi
#fi


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
alias cp="cp -v" 2>/dev/null
alias mv="mv -v" 2>/dev/null
alias vim="mvim -fg" 2>/dev/null


# Plugins (antigen)
source /usr/local/opt/antigen/share/antigen.zsh
antigen use oh-my-zsh                               # Load the oh-my-zsh library

# Bundles from the default repo (robbyrussell's oh-my-zsh)
antigen bundle adb
antigen bundle brew
antigen bundle brew-cask
antigen bundle django
antigen bundle git
antigen bundle npm
antigen bundle pip
antigen bundle python
antigen bundle sbt
antigen bundle scala
antigen bundle ssh-agent
antigen bundle virtualenvwrapper

# Third party bundles
antigen bundle zsh-users/zsh-completions src
antigen bundle zsh-users/zsh-syntax-highlighting

# Themes
antigen theme bhilburn/powerlevel9k powerlevel9k

# Apply antigen stuff!
antigen apply

#
# Powerlevel9k settings
#
DEFAULT_USER=rolf
POWERLEVEL9K_MODE="awesome"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6

#
# oh-my-zsh settings
#
export ZSH=/Users/rolf/.oh-my-zsh       # Path to your oh-my-zsh installation.
CASE_SENSITIVE="true"                   # Uncomment the following line to use case-sensitive completion.

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


#
# User configuration
#
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Users/rolf/.rbenv/shims:/Users/rolf/Library/Android/sdk/platform-tools:/Users/rolf/Library/Android/sdk/tools:/Users/rolf/Library/Android/sdk/bin:~/.bin:/usr/local/sbin:/usr/local/opt/go/libexec/bin:/Users/rolf/.rvm/bin"
export SSH_KEY_PATH="~/.ssh/rsa_id"     # Default ssh key
export LANG=no_NO.UTF-8                 # Language settings
export LC_ALL=no_NO.UTF-8               # Language settings

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
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
alias cp="cp -v" 2>/dev/null
alias mv="mv -v" 2>/dev/null
alias vim="mvim -fg" 2>/dev/null

#
# Key bindings
# See http://stackoverflow.com/a/29403520/1326249 for iTerm2 bindings
#
bindkey "^X\\x7f" backward-kill-line        # Fix for the non-working CMD-Backspace for deleting the line


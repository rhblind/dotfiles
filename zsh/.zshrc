# Load Antigen
source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh library
antigen use oh-my-zsh

#
# Antigen Bundles
#

antigen bundle adb                      # Android Debug Bridge
antigen bundle aws                      # Amazon Web Services
antigen bundle django                   # Django
antigen bundle git                      # Git
antigen bundle git-flow                 # Support for git-flow completions
antigen bundle golang                   # Go
antigen bundle npm                      # Node Package Manager
antigen bundle nvm                      # Node Virtual Manager
antigen bundle node                     # Node
antigen bundle pip                      # Python Package Manager
antigen bundle python                   # Python
antigen bundle sbt                      # Simple Build Tool (Scala)
antigen bundle scala                    # Scala
antigen bundle ssh-agent                # Auto start SSH Agent
antigen bundle tmux                     # Tmux stuff
antigen bundle tmuxinator               # Tmux stuff (I guess...)
antigen bundle virtualenvwrapper        # Python Virtual Environment Manager

# Third party bundles
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src

# Themes
antigen theme bhilburn/powerlevel9k powerlevel9k

# Apply antigen stuff!
antigen apply

# Extra zsh-completions from Homebrew
fpath=($(brew --prefix)/share/zsh-completions $fpath)

#
# Powerlevel9k settings
#
DEFAULT_USER=$USER
POWERLEVEL9K_MODE="compatible"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(virtualenv context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
POWERLEVEL9K_VIRTUALENV_BACKGROUND='white'
AWS_DEFAULT_PROFILE="default"

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
# Key bindings
# See http://stackoverflow.com/a/29403520/1326249 for iTerm2 bindings
#
bindkey "^X\\x7f" backward-kill-line        # Fix for the non-working CMD-Backspace for deleting the line

# if you do a 'rm *', Zsh will give you a sanity check!
# setopt RM_STAR_WAIT

# Zsh has spelling corrector
unsetopt autopushd
unsetopt CORRECT

# added by travis gem
[ -f /Users/rolf/.travis/travis.sh ] && source /Users/rolf/.travis/travis.sh

export PATH="$HOME/.yarn/bin:$PATH"

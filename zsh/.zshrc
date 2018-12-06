# Antigen
# source $HOME/.zshenv-antigen

# Zplug
source $(brew --prefix zplug)/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "bobsoppe/zsh-ssh-agent", use:ssh-agent.zsh, from:github
zplug "bhilburn/powerlevel9k",  use:powerlevel9k.zsh-theme
zplug "plugins/django",         from:oh-my-zsh
zplug "plugins/git",            from:oh-my-zsh
zplug "plugins/git-flow",       from:oh-my-zsh
zplug "plugins/tmux",           from:oh-my-zsh

# Load zplug
zplug load

# Extra zsh-completions from Homebrew
fpath=($(brew --prefix)/share/zsh-completions $fpath)

#
# Powerlevel9k settings
#
DEFAULT_USER=$USER
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
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
# See http://stackoverflow.com/a/29403520/1326249 for iTerm2 bindings
#
bindkey "^X\\x7f" backward-kill-line
bindkey "^X\\x0b" kill-line
bindkey "^K"  kill-whole-line
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^[d" delete-word

# if you do a 'rm *', Zsh will give you a sanity check!
setopt RM_STAR_WAIT

unsetopt autopushd  # Normal pushd/popd behaviour
unsetopt CORRECT    # Disable Zsh spelling corrector

# added by travis gem
[ -f /Users/rolf/.travis/travis.sh ] && source /Users/rolf/.travis/travis.sh


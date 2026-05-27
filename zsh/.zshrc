# The .zshrc file is sourced every time a new zsh shell is started
# and are meant to be used by interactive shells.
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Appearance switching (zsh-appearance-control)
export ZAC_IO_CMD="$HOME/.dotfiles/zsh/bin/appearance-tmux-switch.sh"
export ZAC_DEFERRED_CALLBACK_FNC=_zac_deferred_callback

_zac_deferred_callback() {
  local is_dark=$1
  if (( is_dark )); then
    export STARSHIP_CONFIG="$HOME/.dotfiles/zsh/starship-dark.toml"
  else
    export STARSHIP_CONFIG="$HOME/.dotfiles/zsh/starship-light.toml"
  fi
}

# Set initial STARSHIP_CONFIG based on current appearance
if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
  export STARSHIP_CONFIG="$HOME/.dotfiles/zsh/starship-dark.toml"
else
  export STARSHIP_CONFIG="$HOME/.dotfiles/zsh/starship-light.toml"
fi

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
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

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

plugins=(
    azure
    colored-man-pages
    emacs
    direnv
    dotnet
    fzf
    git
    grepai
    golang
    history-substring-search
    kubectl
    minikube
    mise
    mix
    npm
    oc
    podman
    rust
    tmux
    z
    zsh-appearance-control
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

## History command configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HIST_STAMPS="dd.mm.yyyy"
HISTSIZE=1000
SAVEHIST=10000

setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# Key bindings
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets
bindkey "^X\\x7f" backward-kill-line
bindkey "^X\\x0b" kill-line
bindkey "^J" vi-down-line-or-history
bindkey "^K" vi-up-line-or-history
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[d" delete-word
bindkey "^[[1;10D" beginning-of-line
bindkey "^[[1;10C" end-of-line
# FZF configuration (fzf plugin binds ^R to fzf-history-widget)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_R_OPTS="
  --height 40%
  --reverse
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'CTRL-Y: copy to clipboard'
"

# Increase file limits
ulimit -n 8192

# GPG Magic (SSH_AUTH_SOCK and GPG_AGENT_INFO are in .zshenv)
export GPG_TTY=$(tty)

# Emacs client (connects to running daemon, starts one if needed)
unalias e 2>/dev/null
e() {
    TERM=xterm-256color emacsclient -nw --alternate-editor="" "$@"
}

# Kill the emacs daemon
ek() {
    emacsclient -e "(kill-emacs)"
}

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/aa646/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Starship prompt
eval "$(starship init zsh)"

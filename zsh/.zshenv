## Enable colorized input
CLICOLOR=1

## Use case sensitive completions
CASE_SENSITIVE="true"

## Local binaries
export PATH=$HOME/.local/bin:$PATH

# MISE
export MISE_DATA_DIR=$HOME/.local/share/mise
export PATH=$MISE_DATA_DIR/shims:$PATH

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# Node global
test -d $HOME/.npm-global/bin && export PATH="$HOME/.npm-global/bin:$PATH"

# Kubernetes stuff
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

## GPG Magic
# export GPG_AGENT_INFO="$(gpgconf --list-dirs agent-socket):$(pgrep gpg-agent):1"

## Emacs
# export EDITOR="emacsclient -c -a \"\""
# export VISUAL="emacsclient -c -a \"\""
export DOOMDIR=$HOME/.doom.d
test -d $HOME/.config/emacs/bin && export PATH="$HOME/.config/emacs/bin:$PATH"

[ -n "$EAT_SHELL_INTEGRATION_DIR" ] &&
    source "$EAT_SHELL_INTEGRATION_DIR/zsh"

## Erlang and Elixir
# Make things nice.
export MIX_OS_DEPS_COMPILE_PARTITION_COUNT=5 # Speed up mix deps.compile by parallelizing. Set to half of your CPU cores.
export ERL_AFLAGS="+pc unicode -kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
export PATH=$HOME/.cache/rebar3/bin:$PATH

## Golang
# test -d $HOME/workspace/golang && export GOPATH="$HOME/workspace/golang"
# test -d $GOPATH/bin && export PATH="$GOPATH/bin:$PATH"
test -f $MISE_DATA_DIR/plugins/golang/set-env.zsh && source $MISE_DATA_DIR/plugins/golang/set-env.zsh

## Rust
test -d $HOME/.cargo/bin && export PATH="$HOME/.cargo/bin:$PATH"
export CARGO_NET_GIT_FETCH_WITH_CLI=true
source "$HOME/.cargo/env"

## .NET
test -f $MISE_DATA_DIR/plugins/dotnet/set-dotnet-env.zsh && source $MISE_DATA_DIR/plugins/dotnet/set-dotnet-env.zsh
test -d $HOME/.dotnet/tools && export PATH=$HOME/.dotnet/tools:$PATH

## LLMs
export AIDER_EDITOR=emacs
export OPENAI_API_BASE=https://api.githubcopilot.com
# export AZURE_API_BASE=https://secmgmt-intility.openai.azure.com/
# export AZURE_API_VERSION=2025-01-01-preview

## Claude Code
export CLAUDE_CODE_USE_FOUNDRY=1
export ANTHROPIC_FOUNDRY_BASE_URL="https://dadp-openai-us2-resource.openai.azure.com/anthropic"
export ANTHROPIC_DEFAULT_SONNET_MODEL='claude-sonnet-4-5'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5'
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-5'
export MAX_MCP_OUTPUT_TOKENS=50000 # Required for hexdocs-mcp to download large docs

## Aliases
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
alias vi="nvim" 2>/dev/null
alias vim="nvim" 2>/dev/null
alias e="emacsclient --alternate-editor='' -r --no-wait $*" 2>/dev/null

test -f $HOME/.zshenv-secrets && source $HOME/.zshenv-secrets

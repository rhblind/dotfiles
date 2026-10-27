#!/bin/sh
# Called by zac ZAC_IO_CMD on appearance change.
# Argument $1: 1 = dark, 0 = light

DOTFILES="$HOME/.dotfiles"
TMUX_BIN=/opt/homebrew/bin/tmux

# Only switch if tmux is running
if ! [ -x "$TMUX_BIN" ] || ! $TMUX_BIN list-sessions >/dev/null 2>&1; then
  exit 0
fi

if [ "$1" = "1" ]; then
  # Dark: source Nord theme files from TPM plugin
  NORD_DIR="$HOME/.config/tmux/plugins/tmux"
  if [ -d "$NORD_DIR" ]; then
    $TMUX_BIN set-environment -g NORD_TMUX_STATUS_DATE_FORMAT "%Y-%m-%d"
    $TMUX_BIN set-environment -g NORD_TMUX_STATUS_TIME_FORMAT "%H:%M"
    $TMUX_BIN source-file "$NORD_DIR/src/nord.conf"
    $TMUX_BIN source-file "$NORD_DIR/src/nord-status-content.conf"
  fi
  $TMUX_BIN set -g window-style 'bg=#333a47'
else
  # Light: source doom-tomorrow-day theme
  "$DOTFILES/tmux/themes/doom-tomorrow-day.tmux"
  $TMUX_BIN set -g window-style 'bg=#f8f8f8'
fi

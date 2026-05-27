#!/usr/bin/env bash
# Doom Tomorrow Day theme loader for tmux
# Based on nordtheme/tmux structure

_current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX=${TMUX_BIN:-/opt/homebrew/bin/tmux}

__cleanup() {
  unset -v _current_dir
  unset -f __load __cleanup
}

__load() {
  $TMUX source-file "$_current_dir/doom-tomorrow-day.conf"

  local no_patched_font=$($TMUX show-option -gqv "@doom_tomorrow_day_no_patched_font")

  if [ "$no_patched_font" != "1" ]; then
    $TMUX source-file "$_current_dir/doom-tomorrow-day-status.conf"
  fi
}

__load
__cleanup

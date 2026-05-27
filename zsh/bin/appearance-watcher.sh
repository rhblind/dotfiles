#!/bin/sh
# Called by launchd when macOS appearance changes.
# Reads current appearance and calls zac dispatcher.

ZAC_DISPATCH="$HOME/.oh-my-zsh/custom/plugins/zsh-appearance-control/bin/appearance-dispatch"
export ZAC_IO_CMD="$HOME/.dotfiles/zsh/bin/appearance-tmux-switch.sh"

if ! [ -x "$ZAC_DISPATCH" ]; then
  exit 0
fi

if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
  is_dark=1
else
  is_dark=0
fi

"$ZAC_DISPATCH" dispatch "$is_dark"

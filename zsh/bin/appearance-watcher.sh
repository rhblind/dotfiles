#!/bin/sh
# Called by launchd when macOS appearance changes.
# Reads current appearance and calls zac dispatcher.

# launchd provides a minimal PATH; add Homebrew so dispatch can find tmux
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

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

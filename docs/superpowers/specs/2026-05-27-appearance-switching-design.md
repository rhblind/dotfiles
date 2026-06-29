# Automatic Light/Dark Appearance Switching

## Overview

Automatically switch tmux theme, zsh prompt (starship), and terminal colors when macOS toggles between light and dark mode. Ghostty already handles terminal palette switching via `light:doom-tomorrow-day,dark:doom-nord`. This spec covers tmux and zsh.

## Architecture

```
macOS appearance toggle
  -> launchd detects ~/.GlobalPreferences.plist change
    -> appearance-watcher.sh
      -> zac dispatcher (appearance-dispatch)
        -> ZAC_IO_CMD: tmux source-file (nord or doom-tomorrow-day)
        -> USR1 to all shells
          -> ZAC_DEFERRED_CALLBACK_FNC: swap STARSHIP_CONFIG, re-render prompt
```

### Components

1. **launchd agent** - watches macOS preferences for appearance changes
2. **zsh-appearance-control (zac)** - coordinates theme switching across tmux and all shells
3. **nordtheme/tmux** - dark tmux theme (TPM plugin)
4. **doom-tomorrow-day.conf** - custom light tmux theme
5. **starship** - prompt with two TOML configs (dark/light)
6. **tmux-battery + tmux-cpu** - status bar info plugins

## File Layout

```
~/.dotfiles/
  tmux/
    .tmux.conf                              # updated config
    themes/
      doom-tomorrow-day.conf                # custom light tmux theme
  zsh/
    .zshrc                                  # zac plugin, starship init, callbacks
    .zshenv                                 # (existing)
    bin/
      appearance-watcher.sh                 # launchd callback script
    starship-dark.toml                      # starship dark mode config (Nord)
    starship-light.toml                     # starship light mode config (Tomorrow Day)

~/Library/LaunchAgents/
  com.dotfiles.appearance-switch.plist      # launchd agent

~/.config/starship/                         # symlink target for active starship config
```

### Symlinks

- `~/.dotfiles/zsh/starship-dark.toml` and `starship-light.toml` are referenced by absolute path from `STARSHIP_CONFIG` env var (no symlink needed, zac callback sets the path directly)
- `~/.dotfiles/zsh/bin/appearance-watcher.sh` referenced by absolute path from the launchd plist

## Component Details

### 1. launchd Agent

File: `~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist`

- `WatchPaths`: `~/Library/Preferences/.GlobalPreferences.plist`
- `ProgramArguments`: path to `appearance-watcher.sh`
- Loaded via `launchctl load`

### 2. appearance-watcher.sh

```sh
#!/bin/sh
# Read current macOS appearance
if defaults read -g AppleInterfaceStyle &>/dev/null; then
  is_dark=1
else
  is_dark=0
fi

# Call zac dispatcher
"$ZSH_CUSTOM/plugins/zsh-appearance-control/bin/appearance-dispatch" dispatch "$is_dark"
```

### 3. zac Configuration (in .zshrc)

Set before sourcing Oh My Zsh:

- `ZAC_IO_CMD`: path to a script that runs `tmux source-file` with the appropriate theme
- `ZAC_DEFERRED_CALLBACK_FNC`: name of a shell function that updates `STARSHIP_CONFIG` and re-renders the prompt

The OMZ plugins list includes `zsh-appearance-control`.

### 4. tmux Themes

**Dark: nordtheme/tmux (TPM)**

Official Nord tmux theme. Installed via TPM: `set -g @plugin 'nordtheme/tmux'`

**Light: doom-tomorrow-day.conf (custom)**

Based on a clone of the nordtheme/tmux plugin structure, with colors replaced using the Ghostty doom-tomorrow-day palette:

| Element              | Color     | Source                    |
|----------------------|-----------|---------------------------|
| Status bg            | #e4e4e4   | selection-background      |
| Status fg            | #4d4d4c   | foreground                |
| Active window bg     | #4271ae   | palette 4 (blue)          |
| Active window fg     | #ffffff   | background                |
| Inactive window fg   | #8e908c   | palette 8 (bright black)  |
| Pane border          | #d6d4d4   | palette 7 (white)         |
| Active pane border   | #4271ae   | palette 4 (blue)          |
| Message bg           | #eab700   | palette 3 (yellow)        |
| Message fg           | #4d4d4c   | foreground                |

### 5. tmux Status Bar Segments

Both themes provide the same status bar layout:

- **Left:** session name
- **Right:** cpu, memory, battery, datetime

Powered by TPM plugins:
- `tmux-plugins/tmux-battery` for `#{battery_percentage}`
- `tmux-plugins/tmux-cpu` for `#{cpu_percentage}` and `#{ram_percentage}`

### 6. Starship Prompt

Two TOML files with identical structure, different color palettes.

**Segments:** directory, git_branch, git_status, cmd_duration, nodejs, python, golang, rust, elixir, java, dotnet

**Dark (starship-dark.toml):** Nord palette
- Directory: `#81A1C1` (blue)
- Git branch: `#A3BE8C` (green)
- Git modified: `#EBCB8B` (yellow)
- Error: `#BF616A` (red)

**Light (starship-light.toml):** doom-tomorrow-day palette
- Directory: `#4271ae` (blue)
- Git branch: `#718c00` (green)
- Git modified: `#eab700` (yellow)
- Error: `#c82829` (red)

### 7. Changes to Existing Files

**tmux/.tmux.conf:**
- Remove tokyo-night plugin and all `@theme_*` options
- Add `nordtheme/tmux` plugin
- Add `tmux-plugins/tmux-battery` and `tmux-plugins/tmux-cpu` plugins
- Add status bar format strings for left/right
- Keep all existing keybindings, settings, resurrect/continuum

**zsh/.zshrc:**
- Remove all powerlevel10k references: instant prompt block, `ZSH_THEME="powerlevel10k/powerlevel10k"`, p10k sourcing, `_IS_EMACS_VTERM` guard
- Remove `powerlevel10k` from OMZ plugins list (if present)
- Add `zsh-appearance-control` to OMZ plugins
- Add `ZAC_IO_CMD`, `ZAC_DEFERRED_CALLBACK_FNC` config before OMZ sourcing
- Add deferred callback function definition
- Add `eval "$(starship init zsh)"` at the end

**Cleanup:**
- Delete `~/.p10k.zsh` and `~/.p10k.zsh.bak`
- Remove `~/.oh-my-zsh/custom/themes/powerlevel10k/` directory (OMZ custom theme)
- Remove `~/.cache/p10k-*` instant prompt cache files

## Dependencies to Install

- `brew install starship`
- `git clone https://github.com/alberti42/zsh-appearance-control.git "$ZSH_CUSTOM/plugins/zsh-appearance-control"`
- TPM install (prefix+I) for nordtheme/tmux, tmux-battery, tmux-cpu

## Initialization Flow

On first setup:
1. Install starship and clone zac
2. Create/symlink all config files
3. Source `.zshrc` in a new shell
4. `zac sync` to set initial appearance state
5. Run `tmux source ~/.tmux.conf` and prefix+I to install new TPM plugins
6. `launchctl load ~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist`

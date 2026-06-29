# Appearance Switching Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Automatically switch tmux theme and zsh prompt colors when macOS toggles between light and dark mode.

**Architecture:** A launchd agent watches macOS preferences and calls the zsh-appearance-control (zac) dispatcher. zac coordinates tmux theme switching (via `ZAC_IO_CMD`) and prompt re-rendering (via `ZAC_DEFERRED_CALLBACK_FNC`). Tmux uses nordtheme/tmux for dark and a custom doom-tomorrow-day theme (cloned from Nord's structure) for light. Starship replaces powerlevel10k as the prompt, with separate dark/light TOML configs.

**Tech Stack:** zsh, tmux, starship, zsh-appearance-control, launchd, Ghostty

**Spec:** `docs/superpowers/specs/2026-05-27-appearance-switching-design.md`

---

### Task 1: Install dependencies

**Files:** None (system-level installs)

- [ ] **Step 1: Install starship**

```bash
brew install starship
```

Expected: `starship --version` prints a version number.

- [ ] **Step 2: Clone zac into OMZ custom plugins**

```bash
git clone https://github.com/alberti42/zsh-appearance-control.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-appearance-control"
```

Expected: `ls ~/.oh-my-zsh/custom/plugins/zsh-appearance-control/zsh-appearance-control.plugin.zsh` exists.

- [ ] **Step 3: Verify the zac dispatcher exists**

```bash
ls ~/.oh-my-zsh/custom/plugins/zsh-appearance-control/bin/appearance-dispatch
```

Expected: file exists and is executable.

---

### Task 2: Remove powerlevel10k

**Files:**
- Modify: `zsh/.zshrc`
- Delete: `~/.p10k.zsh`, `~/.p10k.zsh.bak`
- Delete: `~/.oh-my-zsh/custom/themes/powerlevel10k/` (directory)
- Delete: `~/.cache/p10k-*` (cache files)

- [ ] **Step 1: Clean up .zshrc**

Remove the commented-out p10k instant prompt block (lines 9-14), the `_IS_EMACS_VTERM` variable (line 7), the commented-out p10k sourcing (lines 173-174), and the `unset _IS_EMACS_VTERM` line (line 175). The `ZSH_THEME=""` on line 26 stays as-is.

Replace the top of the file (lines 1-14) with:

```zsh
# The .zshrc file is sourced every time a new zsh shell is started
# and are meant to be used by interactive shells.
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
```

Remove lines 173-175 (the p10k sourcing block and unset):

```zsh
# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# (( ! _IS_EMACS_VTERM )) && [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
unset _IS_EMACS_VTERM
```

- [ ] **Step 2: Delete p10k config files**

```bash
rm -f ~/.p10k.zsh ~/.p10k.zsh.bak
```

- [ ] **Step 3: Delete p10k cache files**

```bash
rm -f ~/.cache/p10k-dump-*.zsh ~/.cache/p10k-dump-*.zsh.zwc
rm -f ~/.cache/p10k-instant-prompt-*.zsh ~/.cache/p10k-instant-prompt-*.zsh.zwc
```

- [ ] **Step 4: Remove p10k OMZ custom theme**

```bash
rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
```

- [ ] **Step 5: Commit**

```bash
git add zsh/.zshrc
git commit -m "chore(zsh): remove powerlevel10k"
```

---

### Task 3: Create doom-tomorrow-day tmux theme

**Files:**
- Create: `tmux/themes/doom-tomorrow-day.conf`
- Create: `tmux/themes/doom-tomorrow-day-status.conf`

This is a clone of the nordtheme/tmux structure (`src/nord.conf` + `src/nord-status-content.conf`), with all colors replaced using the Ghostty doom-tomorrow-day palette.

Color mapping from doom-tomorrow-day Ghostty theme:

| Nord semantic   | Nord color    | Tomorrow Day replacement |
|-----------------|---------------|--------------------------|
| black (bg)      | terminal bg   | `#ffffff`                |
| brightblack     | `#4C566A`     | `#8e908c`                |
| white           | `#D8DEE9`     | `#d6d4d4`                |
| blue            | `#81A1C1`     | `#4271ae`                |
| cyan            | `#88C0D0`     | `#3e999f`                |
| brightcyan      | `#88C0D0`     | `#8abeb7`                |
| fg (white)      | `#ECEFF4`     | `#4d4d4c`                |

- [ ] **Step 1: Create themes directory**

```bash
mkdir -p tmux/themes
```

- [ ] **Step 2: Create doom-tomorrow-day.conf**

This mirrors `src/nord.conf` from the Nord plugin. Note: the Nord plugin uses tmux named colors (`black`, `blue`, `brightblack` etc.) which map to the terminal's ANSI palette. For our custom theme we use hex values for precision.

Create `tmux/themes/doom-tomorrow-day.conf`:

```conf
# Doom Tomorrow Day theme for tmux
# Based on nordtheme/tmux structure, colors from doom-tomorrow-day Ghostty theme

#+----------------+
#+ Plugin Support +
#+----------------+
#+--- tmux-prefix-highlight ---+
set -g @prefix_highlight_fg "#ffffff"
set -g @prefix_highlight_bg "#3e999f"

#+---------+
#+ Options +
#+---------+
set -g status-interval 1
set -g status on

#+--------+
#+ Status +
#+--------+
#+--- Layout ---+
set -g status-justify left

#+--- Colors ---+
set -g status-style "bg=#e4e4e4,fg=#4d4d4c"

#+-------+
#+ Panes +
#+-------+
set -g pane-border-style "bg=default,fg=#d6d4d4"
set -g pane-active-border-style "bg=default,fg=#4271ae"
set -g display-panes-colour "#8e908c"
set -g display-panes-active-colour "#4d4d4c"

#+------------+
#+ Clock Mode +
#+------------+
setw -g clock-mode-colour "#3e999f"

#+----------+
#+ Messages +
#+---------+
set -g message-style "bg=#d6d4d4,fg=#4d4d4c"
set -g message-command-style "bg=#d6d4d4,fg=#4d4d4c"
```

- [ ] **Step 3: Create doom-tomorrow-day-status.conf**

This mirrors `src/nord-status-content.conf`. Uses powerline glyphs (same as Nord). The status-right includes battery, cpu, ram, and datetime segments using TPM plugin format strings.

Create `tmux/themes/doom-tomorrow-day-status.conf`:

```conf
# Doom Tomorrow Day status content for tmux
# Based on nordtheme/tmux structure

#+----------------+
#+ Plugin Support +
#+----------------+
#+--- tmux-prefix-highlight ---+
set -g @prefix_highlight_output_prefix "#[fg=#3e999f]#[bg=#e4e4e4]#[nobold]#[noitalics]#[nounderscore]#[bg=#3e999f]#[fg=#ffffff]"
set -g @prefix_highlight_output_suffix ""
set -g @prefix_highlight_copy_mode_attr "fg=#3e999f,bg=#e4e4e4,bold"

#+--------+
#+ Status +
#+--------+
#+--- Bars ---+
set -g status-left "#[fg=#ffffff,bg=#4271ae,bold] #S #[fg=#4271ae,bg=#e4e4e4,nobold,noitalics,nounderscore]"
set -g status-right "#{prefix_highlight}#[fg=#d6d4d4,bg=#e4e4e4,nobold,noitalics,nounderscore]#[fg=#4d4d4c,bg=#d6d4d4] CPU:#{cpu_percentage} #[fg=#4d4d4c,bg=#d6d4d4,nobold,noitalics,nounderscore]#[fg=#4d4d4c,bg=#d6d4d4] RAM:#{ram_percentage} #[fg=#4d4d4c,bg=#d6d4d4,nobold,noitalics,nounderscore]#[fg=#4d4d4c,bg=#d6d4d4] #{battery_percentage} #[fg=#4d4d4c,bg=#d6d4d4,nobold,noitalics,nounderscore]#[fg=#4d4d4c,bg=#d6d4d4] %Y-%m-%d %H:%M #[fg=#3e999f,bg=#d6d4d4,nobold,noitalics,nounderscore]#[fg=#ffffff,bg=#3e999f,bold] #H "

#+--- Windows ---+
set -g window-status-format "#[fg=#e4e4e4,bg=#d6d4d4,nobold,noitalics,nounderscore] #[fg=#4d4d4c,bg=#d6d4d4]#I #[fg=#4d4d4c,bg=#d6d4d4,nobold,noitalics,nounderscore] #[fg=#4d4d4c,bg=#d6d4d4]#W #F #[fg=#d6d4d4,bg=#e4e4e4,nobold,noitalics,nounderscore]"
set -g window-status-current-format "#[fg=#e4e4e4,bg=#3e999f,nobold,noitalics,nounderscore] #[fg=#ffffff,bg=#3e999f]#I #[fg=#ffffff,bg=#3e999f,nobold,noitalics,nounderscore] #[fg=#ffffff,bg=#3e999f]#W #F #[fg=#3e999f,bg=#e4e4e4,nobold,noitalics,nounderscore]"
set -g window-status-separator ""
```

- [ ] **Step 4: Commit**

```bash
git add tmux/themes/
git commit -m "feat(tmux): add doom-tomorrow-day light theme"
```

---

### Task 4: Update tmux.conf

**Files:**
- Modify: `tmux/.tmux.conf`

- [ ] **Step 1: Replace the theme section**

Remove the tokyo-night theme block (lines 124-136):

```conf
# Theme

## Tokyo Night theme
set -g @plugin 'fabioluciano/tmux-tokyo-night'
set -g @theme_variation 'day'
set -g @theme_plugins 'datetime,battery,cpu,memory'

### Battery plugin
set -g @theme_plugin_battery_display_threshold '100'
set -g @theme_plugin_battery_display_condition 'lt'
set -g @theme_plugin_battery_cache_ttl 30
set -g @theme_plugin_battery_warning_threshold '50'   # Yellow warning at 50%
set -g @theme_plugin_battery_critical_threshold '30'  # Red critical at 30%
```

Replace with:

```conf
# Theme - Nord (dark), switched to doom-tomorrow-day (light) by zac
set -g @plugin 'nordtheme/tmux'

# Status bar info plugins
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-cpu'
```

- [ ] **Step 2: Remove the custom status bar format strings**

Remove lines 103 and 109-110 which set custom status-left/right and window-status formats. The Nord plugin and our custom theme handle these:

```conf
set -g status-left " #S "
```

and:

```conf
set -g window-status-format " #I: #W "
set -g window-status-current-format " #I: #W "
```

Remove those lines (the Nord plugin sets its own status bar formatting).

Also remove the commented-out status style lines 104, 106-107 if present.

- [ ] **Step 3: Commit**

```bash
git add tmux/.tmux.conf
git commit -m "feat(tmux): switch to nord theme with battery and cpu plugins"
```

---

### Task 5: Create starship configs

**Files:**
- Create: `zsh/starship-dark.toml`
- Create: `zsh/starship-light.toml`

- [ ] **Step 1: Create starship-dark.toml**

Nord palette. Create `zsh/starship-dark.toml`:

```toml
palette = "nord"

format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$golang\
$rust\
$elixir\
$java\
$dotnet\
$cmd_duration\
$line_break\
$character"""

[palettes.nord]
nord_blue = "#81A1C1"
nord_green = "#A3BE8C"
nord_yellow = "#EBCB8B"
nord_red = "#BF616A"
nord_purple = "#B48EAD"
nord_cyan = "#88C0D0"
nord_fg = "#ECEFF4"
nord_dim = "#4C566A"

[character]
success_symbol = "[>](bold nord_green)"
error_symbol = "[>](bold nord_red)"

[directory]
style = "bold nord_blue"
truncation_length = 3
truncate_to_repo = false

[git_branch]
style = "bold nord_green"
format = "[$symbol$branch(:$remote_branch)]($style) "

[git_status]
style = "nord_yellow"
format = '([\[$all_status$ahead_behind\]]($style) )'

[cmd_duration]
style = "nord_dim"
min_time = 3_000
format = "[$duration]($style) "

[nodejs]
style = "nord_green"
format = "[$symbol($version)]($style) "

[python]
style = "nord_cyan"
format = "[$symbol($version)]($style) "

[golang]
style = "nord_cyan"
format = "[$symbol($version)]($style) "

[rust]
style = "nord_red"
format = "[$symbol($version)]($style) "

[elixir]
style = "nord_purple"
format = "[$symbol($version)]($style) "

[java]
style = "nord_blue"
format = "[$symbol($version)]($style) "

[dotnet]
style = "nord_purple"
format = "[$symbol($version)]($style) "
```

- [ ] **Step 2: Create starship-light.toml**

Doom Tomorrow Day palette. Create `zsh/starship-light.toml`:

```toml
palette = "tomorrow_day"

format = """
$directory\
$git_branch\
$git_status\
$nodejs\
$python\
$golang\
$rust\
$elixir\
$java\
$dotnet\
$cmd_duration\
$line_break\
$character"""

[palettes.tomorrow_day]
td_blue = "#4271ae"
td_green = "#718c00"
td_yellow = "#eab700"
td_red = "#c82829"
td_purple = "#8959a8"
td_cyan = "#3e999f"
td_fg = "#4d4d4c"
td_dim = "#8e908c"

[character]
success_symbol = "[>](bold td_green)"
error_symbol = "[>](bold td_red)"

[directory]
style = "bold td_blue"
truncation_length = 3
truncate_to_repo = false

[git_branch]
style = "bold td_green"
format = "[$symbol$branch(:$remote_branch)]($style) "

[git_status]
style = "td_yellow"
format = '([\[$all_status$ahead_behind\]]($style) )'

[cmd_duration]
style = "td_dim"
min_time = 3_000
format = "[$duration]($style) "

[nodejs]
style = "td_green"
format = "[$symbol($version)]($style) "

[python]
style = "td_cyan"
format = "[$symbol($version)]($style) "

[golang]
style = "td_cyan"
format = "[$symbol($version)]($style) "

[rust]
style = "td_red"
format = "[$symbol($version)]($style) "

[elixir]
style = "td_purple"
format = "[$symbol($version)]($style) "

[java]
style = "td_blue"
format = "[$symbol($version)]($style) "

[dotnet]
style = "td_purple"
format = "[$symbol($version)]($style) "
```

- [ ] **Step 3: Commit**

```bash
git add zsh/starship-dark.toml zsh/starship-light.toml
git commit -m "feat(zsh): add starship dark and light configs"
```

---

### Task 6: Create appearance watcher script

**Files:**
- Create: `zsh/bin/appearance-watcher.sh`

- [ ] **Step 1: Create bin directory**

```bash
mkdir -p zsh/bin
```

- [ ] **Step 2: Create appearance-watcher.sh**

Create `zsh/bin/appearance-watcher.sh`:

```sh
#!/bin/sh
# Called by launchd when macOS appearance changes.
# Reads current appearance and calls zac dispatcher.

ZAC_DISPATCH="$HOME/.oh-my-zsh/custom/plugins/zsh-appearance-control/bin/appearance-dispatch"

if ! [ -x "$ZAC_DISPATCH" ]; then
  exit 0
fi

if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
  is_dark=1
else
  is_dark=0
fi

"$ZAC_DISPATCH" dispatch "$is_dark"
```

- [ ] **Step 3: Make it executable**

```bash
chmod +x zsh/bin/appearance-watcher.sh
```

- [ ] **Step 4: Commit**

```bash
git add zsh/bin/appearance-watcher.sh
git commit -m "feat(zsh): add appearance watcher script for launchd"
```

---

### Task 7: Create ZAC_IO_CMD script for tmux theme switching

**Files:**
- Create: `zsh/bin/appearance-tmux-switch.sh`

This script is called by zac's dispatcher (via `ZAC_IO_CMD`) once per appearance change. It sources the correct tmux theme. It runs outside the shell signal handler, so `tmux source-file` is safe here.

- [ ] **Step 1: Create appearance-tmux-switch.sh**

Create `zsh/bin/appearance-tmux-switch.sh`:

```sh
#!/bin/sh
# Called by zac ZAC_IO_CMD on appearance change.
# Argument $1: 1 = dark, 0 = light

DOTFILES="$HOME/.dotfiles"

# Only switch if tmux is running
if ! command -v tmux >/dev/null 2>&1 || ! tmux list-sessions >/dev/null 2>&1; then
  exit 0
fi

if [ "$1" = "1" ]; then
  # Dark: source Nord theme files from TPM plugin
  NORD_DIR="$HOME/.tmux/plugins/tmux"
  if [ -d "$NORD_DIR" ]; then
    tmux source-file "$NORD_DIR/src/nord.conf"
    tmux source-file "$NORD_DIR/src/nord-status-content.conf"
  fi
else
  # Light: source doom-tomorrow-day theme
  tmux source-file "$DOTFILES/tmux/themes/doom-tomorrow-day.conf"
  tmux source-file "$DOTFILES/tmux/themes/doom-tomorrow-day-status.conf"
fi
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x zsh/bin/appearance-tmux-switch.sh
```

- [ ] **Step 3: Commit**

```bash
git add zsh/bin/appearance-tmux-switch.sh
git commit -m "feat(zsh): add tmux theme switching script for zac"
```

---

### Task 8: Update .zshrc with zac and starship

**Files:**
- Modify: `zsh/.zshrc`

- [ ] **Step 1: Add zac configuration before OMZ sourcing**

After `ZSH_THEME=""` (line 26) and before the `plugins=(` block (line 89), add the zac config and the deferred callback function. Insert after line 26:

```zsh
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
```

- [ ] **Step 2: Add zsh-appearance-control to plugins list**

Add `zsh-appearance-control` to the `plugins=(...)` array in `.zshrc`. Insert it before `zsh-autosuggestions`:

```zsh
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
```

- [ ] **Step 3: Add starship init at end of file**

Replace the Docker completions block at the end of `.zshrc` (lines 188-192) and add starship init. The final lines of the file should be:

```zsh
# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Starship prompt
eval "$(starship init zsh)"
```

- [ ] **Step 4: Verify .zshrc syntax**

```bash
zsh -n ~/.zshrc
```

Expected: no output (no syntax errors).

- [ ] **Step 5: Commit**

```bash
git add zsh/.zshrc
git commit -m "feat(zsh): add zac appearance switching and starship prompt"
```

---

### Task 9: Create and load launchd agent

**Files:**
- Create: `~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist`

- [ ] **Step 1: Create the launchd plist**

Create `~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.appearance-switch</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/sh</string>
        <string>-c</string>
        <string>$HOME/.dotfiles/zsh/bin/appearance-watcher.sh</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Users/aa646/Library/Preferences/.GlobalPreferences.plist</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/appearance-switch.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/appearance-switch.err</string>
</dict>
</plist>
```

Note: `WatchPaths` requires an absolute path (launchd does not expand `~`). `$HOME` in `ProgramArguments` is NOT expanded by launchd either, so we use `/bin/sh -c` to get shell expansion.

- [ ] **Step 2: Load the agent**

```bash
launchctl load ~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist
```

Expected: no error output.

- [ ] **Step 3: Verify it loaded**

```bash
launchctl list | grep appearance
```

Expected: a line containing `com.dotfiles.appearance-switch`.

---

### Task 10: Install TPM plugins and test

**Files:** None (runtime verification)

- [ ] **Step 1: Source updated zshrc**

Open a new terminal tab/window, or:

```bash
exec zsh
```

Expected: starship prompt appears (a `>` character, no p10k prompt).

- [ ] **Step 2: Install new TPM plugins**

Inside tmux, press `Ctrl-Space I` (prefix + I) to install the new plugins (nordtheme/tmux, tmux-battery, tmux-cpu).

Expected: TPM reports successful installation of the new plugins.

- [ ] **Step 3: Source tmux config**

```bash
tmux source-file ~/.tmux.conf
```

Expected: Nord theme applies to tmux status bar.

- [ ] **Step 4: Sync zac initial state**

```bash
zac sync
```

Expected: current appearance state is set. `zac status` prints `1` (dark) or `0` (light).

- [ ] **Step 5: Test appearance switching**

Toggle macOS appearance (System Settings > Appearance, or `dark-mode` CLI). Verify:
- Ghostty terminal colors change (doom-nord / doom-tomorrow-day)
- Tmux status bar switches between Nord (dark) and doom-tomorrow-day (light)
- Starship prompt colors update on the next prompt render

- [ ] **Step 6: Check logs if switching doesn't work**

```bash
cat /tmp/appearance-switch.log
cat /tmp/appearance-switch.err
```

- [ ] **Step 7: Final commit**

```bash
git add -A
git commit -m "feat: automatic light/dark appearance switching"
```

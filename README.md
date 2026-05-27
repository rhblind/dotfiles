# dotfiles

Personal dotfiles for macOS. Configuration for zsh, tmux, Ghostty, AeroSpace, and more.

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- A [Nerd Font](https://www.nerdfonts.com/) (for powerline glyphs and icons)
- [Ghostty](https://ghostty.org/) terminal (or any terminal with light/dark theme support)
- [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`)

## Installation

### Clone

```sh
git clone git@github.com:<user>/dotfiles.git ~/.dotfiles
```

### Zsh

Install [Oh My Zsh](https://ohmyz.sh/):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install [zsh-appearance-control](https://github.com/alberti42/zsh-appearance-control) (automatic light/dark mode switching):

```sh
git clone https://github.com/alberti42/zsh-appearance-control.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-appearance-control
```

Install [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions):

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Install [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting):

```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Symlink config files:

```sh
cd ~/.dotfiles && stow zsh
```

### Starship Prompt

Install [Starship](https://starship.rs/):

```sh
brew install starship
```

Two config files handle light/dark theming. They are selected automatically by zsh-appearance-control. No symlinks needed; `.zshrc` points to them directly via `STARSHIP_CONFIG`.

- `zsh/starship-dark.toml` - Nord color palette
- `zsh/starship-light.toml` - Doom Tomorrow Day color palette

### Tmux

Install tmux:

```sh
brew install tmux
```

Install [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager):

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Symlink the config:

```sh
cd ~/.dotfiles && stow tmux
```

Start tmux and install plugins:

```
Ctrl-Space I
```

This installs:

- [nordtheme/tmux](https://github.com/nordtheme/tmux) - Dark theme
- [tmux-battery](https://github.com/tmux-plugins/tmux-battery) - Battery status
- [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) - CPU/RAM status
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) - Session persistence
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) - Automatic session saving/restoring

#### Tmux Light Theme (Doom Tomorrow Day)

A custom light theme for tmux that mirrors the Nord dark theme structure, using colors from the [doom-tomorrow-day](https://github.com/doomemacs/themes) Emacs theme. Located at `tmux/themes/`:

- `doom-tomorrow-day.conf` - Base colors, panes, messages
- `doom-tomorrow-day-status.conf` - Status bar with powerline glyphs
- `doom-tomorrow-day.tmux` - Loader script (sources both files)

The theme is loaded automatically by the appearance switching system. To load it manually:

```sh
bash ~/.dotfiles/tmux/themes/doom-tomorrow-day.tmux
```

### Appearance Switching (Light/Dark Mode)

Automatic theme switching across the terminal stack when macOS toggles between light and dark mode.

**How it works:**

1. A launchd agent watches `~/Library/Preferences/.GlobalPreferences.plist` for changes
2. When macOS appearance changes, it runs `zsh/bin/appearance-watcher.sh`
3. The watcher calls zsh-appearance-control (zac) dispatch
4. zac triggers `zsh/bin/appearance-tmux-switch.sh` (via `ZAC_IO_CMD`) to switch tmux themes
5. zac triggers the deferred callback in `.zshrc` to switch the starship prompt config
6. Ghostty handles its own switching via `theme = light:doom-tomorrow-day,dark:doom-nord`

**Install the launchd agent:**

```sh
ln -sf ~/.dotfiles/launchd/com.dotfiles.appearance-switch.plist \
  ~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist
launchctl load ~/Library/LaunchAgents/com.dotfiles.appearance-switch.plist
```

Note: The launchd plist uses a manual symlink since it needs to go into `~/Library/LaunchAgents/`, not the home directory.

**Verify it's running:**

```sh
launchctl list | grep appearance
```

**Key files:**

| File | Purpose |
|------|---------|
| `launchd/com.dotfiles.appearance-switch.plist` | launchd agent, triggers on appearance change |
| `zsh/bin/appearance-watcher.sh` | Reads current appearance, calls zac dispatch |
| `zsh/bin/appearance-tmux-switch.sh` | Switches tmux between Nord and doom-tomorrow-day |
| `tmux/themes/doom-tomorrow-day.*` | Custom light theme for tmux |
| `zsh/starship-dark.toml` | Starship prompt, Nord palette |
| `zsh/starship-light.toml` | Starship prompt, Tomorrow Day palette |

### Tmux Key Bindings

The prefix key is `Ctrl-Space`.

| Binding | Action |
|---------|--------|
| `Ctrl-Space I` | Install TPM plugins |
| `Ctrl-Space r` | Reload tmux config |
| `Ctrl-Space v` | Split pane vertically |
| `Ctrl-Space s` | Split pane horizontally |
| `Ctrl-Space h/j/k/l` | Navigate panes (vim-style) |
| `Shift-Left/Right` | Switch windows |
| `Alt-1..9` | Jump to window by number |
| `Ctrl-Space Enter` | Enter copy mode |
| `Ctrl-Space Ctrl-Space` | Toggle last window |

## Directory Structure

```
~/.dotfiles/
  aerospace/       AeroSpace window manager config
  bash/            Bash config (legacy)
  docs/            Design specs and implementation plans
  gnupg/           GPG agent config
  launchd/         launchd agents (symlinked to ~/Library/LaunchAgents/)
  tmux/
    .tmux.conf     Tmux config (symlinked to ~/.tmux.conf)
    themes/        Custom tmux themes (doom-tomorrow-day)
  vim/             Vim/Neovim config
  warp/            Warp terminal config
  zsh/
    .zshrc         Zsh interactive config (symlinked to ~/.zshrc)
    .zshenv        Zsh environment variables (symlinked to ~/.zshenv)
    bin/            Helper scripts (appearance switching)
    starship-dark.toml   Starship prompt config (dark)
    starship-light.toml  Starship prompt config (light)
```

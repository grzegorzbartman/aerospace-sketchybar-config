# AeroSpace + SketchyBar Configuration

Configuration files for AeroSpace window manager and SketchyBar status bar integration. This setup provides a tiling window management experience with keyboard shortcuts optimized to avoid conflicts with Polish characters, along with a minimal, functional status bar showing workspace indicators, current app, battery, volume, and clock.

## Features

- **AeroSpace**: Tiling window manager with customized keyboard shortcuts
- **SketchyBar**: Minimal status bar with AeroSpace workspace integration
- **Workspace indicators**: Visual feedback for current workspace
- **Quick app launchers**: Keyboard shortcuts for frequently used apps
- **System info**: Battery, volume, clock, and active application display

## Prerequisites

Before installation, ensure you have the following installed:

1. **AeroSpace** - [Installation guide](https://github.com/nikitabobko/AeroSpace)
2. **SketchyBar** - [Installation guide](https://github.com/FelixKratz/SketchyBar)
   ```bash
   brew install sketchybar
   ```
3. **Hack Nerd Font** - Required for icons in SketchyBar
   ```bash
   brew install --cask font-hack-nerd-font
   ```

## Installation

### 1. Clone the repository

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-sketchybar-config.git
```

### 2. Create symlinks

#### AeroSpace configuration

```bash
cd ~
ln -s ~/projects/aerospace-sketchybar-config/aerospace/.aerospace.toml .aerospace.toml
```

#### SketchyBar configuration

```bash
cd ~/.config
ln -s ~/projects/aerospace-sketchybar-config/sketchybar sketchybar
```

### 3. Start services

AeroSpace will start automatically at login (configured in `.aerospace.toml`). SketchyBar will be launched automatically by AeroSpace.

To start manually:
```bash
brew services start sketchybar
aerospace reload-config
```

### 4. Optional: Enable Dock autohide

For a cleaner desktop experience:
```bash
defaults write com.apple.dock autohide -bool true && killall Dock
defaults write com.apple.dock autohide-delay -float 0 && killall Dock
```

## Keyboard Shortcuts

### Window Management

- `Ctrl+Alt+H/J/K/L` - Focus window (left/down/up/right)
- `Alt+Shift+H/J/K/L` - Move window (left/down/up/right)
- `Alt+Minus/Equal` - Resize window
- `Alt+Slash` - Toggle horizontal/vertical layout
- `Alt+Comma` - Toggle accordion layout
- `Alt+F` - Toggle floating/tiling mode

### Workspaces

- `Alt+1-9/0` - Switch to workspace 1-10
- `Alt+Shift+1-9/0` - Move window to workspace 1-10
- `Alt+Left/Right` - Switch to previous/next workspace
- `Alt+Shift+Left/Right` - Move window to previous/next workspace

### Quick App Launchers

- `Ctrl+Alt+B` - Safari
- `Ctrl+Alt+T` - iTerm
- `Ctrl+Alt+C` - Cursor
- `Ctrl+Alt+Z` - Todoist
- `Ctrl+Alt+N` - Notes (new note)
- `Ctrl+Alt+M` - Mimestream
- `Ctrl+Alt+P` - PhpStorm

### Service Mode

- `Alt+Shift+;` - Enter service mode
  - `Esc` - Reload config and exit
  - `R` - Reset layout
  - `F` - Toggle floating/tiling
  - `Backspace` - Close all windows except current
  - `Up/Down` - Volume control

## Configuration Files

```
aerospace-sketchybar-config/
├── aerospace/
│   └── .aerospace.toml          # AeroSpace configuration
└── sketchybar/
    ├── sketchybarrc             # SketchyBar main config
    └── plugins/
        ├── aerospace.sh         # Workspace indicator logic
        ├── battery.sh           # Battery status
        ├── clock.sh             # Date and time
        ├── front_app.sh         # Active application name
        ├── volume.sh            # Volume indicator
        └── wifi.sh              # WiFi status
```

## Customization

### Modifying Workspaces

Edit the workspace shortcuts in `aerospace/.aerospace.toml`:
```toml
[mode.main.binding]
alt-1 = 'workspace 1'
# Add more as needed
```

### Changing SketchyBar Appearance

Edit `sketchybar/sketchybarrc` to customize:
- Bar position and height
- Colors and transparency
- Font sizes
- Item spacing

### Adding Custom Plugins

Create new shell scripts in `sketchybar/plugins/` and add them to `sketchybarrc`.

## Additional Settings

### Autohide macOS Dock

For a cleaner desktop experience, you can enable automatic hiding of the macOS Dock:

```bash
defaults write com.apple.dock autohide -bool true && killall Dock
```

To remove the delay when showing/hiding the Dock:

```bash
defaults write com.apple.dock autohide-delay -float 0 && killall Dock
```

To restore the default delay:

```bash
defaults delete com.apple.dock autohide-delay && killall Dock
```

To disable autohide:

```bash
defaults write com.apple.dock autohide -bool false && killall Dock
```

### Mission Control Fix

Mission Control may display windows too small when AeroSpace places many windows in the bottom right corner. To fix this, enable "Group windows by application":

```bash
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

Or via System Settings: **Desktop & Dock → Group windows by application**

## Updating Configuration

Since configurations are symlinked, any changes made to the files in this repository will immediately affect your system. To sync changes across multiple computers:

```bash
cd ~/projects/aerospace-sketchybar-config
git pull origin main
aerospace reload-config
sketchybar --reload
```

To push your improvements:

```bash
cd ~/projects/aerospace-sketchybar-config
git add .
git commit -m "Description of changes"
git push origin main
```

## Troubleshooting

### SketchyBar not showing
```bash
brew services restart sketchybar
```

### AeroSpace not responding
```bash
aerospace reload-config
```

### Workspaces not updating in SketchyBar
Ensure the aerospace event trigger is properly configured and the plugin script is executable:
```bash
chmod +x ~/.config/sketchybar/plugins/*.sh
```

## Resources

- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/)
- [SketchyBar Documentation](https://felixkratz.github.io/SketchyBar/)
- [AeroSpace + SketchyBar Integration Guide](https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar)

## License

This configuration is free to use and modify for personal use.


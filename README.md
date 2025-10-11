# AeroSpace + SketchyBar Configuration

Configuration files for AeroSpace window manager and SketchyBar status bar integration. This setup provides a tiling window management experience with keyboard shortcuts optimized to avoid conflicts with Polish characters, along with a minimal, functional status bar showing workspace indicators with app icons, current app, battery, volume, and clock.

## Features

- **AeroSpace**: Tiling window manager with customized keyboard shortcuts
- **SketchyBar**: Minimal status bar with AeroSpace workspace integration
- **Window borders**: Visual borders around active windows (JankyBorders)
- **Workspace indicators**: Visual feedback for current workspace with app icons
- **App icons in workspaces**: See which applications are running in each workspace
- **Quick app launchers**: Keyboard shortcuts for frequently used apps
- **System info**: Battery, volume, clock, and active application display

## Quick Install (Automated)

**The easiest way to install everything!** Run the automated installation script:

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-sketchybar-config.git
cd aerospace-sketchybar-config
./install.sh
```

The `install.sh` script will:
- ✓ Check if Homebrew is installed
- ✓ Install AeroSpace, SketchyBar, JankyBorders, Ghostty, and Hack Nerd Font
- ✓ Create symlinks for configuration files
- ✓ Set up proper permissions
- ✓ Start all services
- ✓ Optionally configure Dock autohide
- ✓ Show detailed progress and what's being installed at each step

**The script is interactive** - it will:
- Show you exactly what's happening at each step
- Ask before reinstalling components that are already present
- Ask before replacing existing configuration files
- Provide detailed verification and next steps

---

## Manual Installation

If you prefer to install components manually or want more control, follow these steps:

### Prerequisites

#### Quick Install (All Dependencies)

Install all required dependencies with a single command:

```bash
brew tap FelixKratz/formulae && brew install sketchybar borders && brew install --cask font-hack-nerd-font ghostty nikitabobko/tap/aerospace
```

#### Individual Components

If you prefer to install components separately or need more information:

1. **AeroSpace** - [Installation guide](https://github.com/nikitabobko/AeroSpace)
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```

2. **SketchyBar** - Status bar for macOS
   ```bash
   brew tap FelixKratz/formulae
   brew install sketchybar
   ```

3. **JankyBorders** - Window borders for active windows
   ```bash
   brew tap FelixKratz/formulae
   brew install borders
   ```

   This adds visual borders around windows to highlight the currently focused window. The configuration includes:
   - Active window: Blue/cyan border (0xff89b4fa)
   - Inactive windows: Dark gray border (0xff45475a)
   - Border width: 8px

4. **Ghostty** - Modern terminal emulator with Tokyo Night theme

   Ghostty is a fast, feature-rich terminal emulator with excellent color support and theming capabilities. This configuration includes Tokyo Night theme setup.

   ```bash
   brew install --cask ghostty
   ```

   After installation, create a symlink to the Ghostty configuration:
   ```bash
   cd ~/.config
   ln -s ~/projects/aerospace-sketchybar-config/ghostty ghostty
   ```

   The configuration includes:
   - Tokyo Night theme (dark, beautiful color scheme)
   - Hack Nerd Font for icons and symbols
   - Proper terminal environment settings for full color support
   - Clipboard integration and mouse support

5. **Nerd Fonts** - Required for displaying app icons in SketchyBar

   Nerd Fonts are patched fonts that include thousands of icons from popular icon sets like Font Awesome, Material Design Icons, Devicons, and more. This configuration uses **Hack Nerd Font** to display beautiful icons for each application running in your workspaces.

   ```bash
   brew install --cask font-hack-nerd-font
   ```

   After installation, the workspace indicators will show icons for your running applications:
   - Terminals (Ghostty, iTerm2, etc.) →
   - Browsers (Safari, Chrome, Firefox) → 󰀹
   - Editors (VS Code, Cursor) → 󰨞
   - Communication (Slack, Discord) → 󰒱 󰙯
   - And many more!

   **Note**: If icons don't display correctly after installation, restart SketchyBar:
   ```bash
   brew services restart sketchybar
   ```

### Installation Steps

#### 1. Clone the repository

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-sketchybar-config.git
```

#### 2. Create symlinks

##### AeroSpace configuration

```bash
cd ~
ln -s ~/projects/aerospace-sketchybar-config/aerospace/.aerospace.toml .aerospace.toml
```

##### SketchyBar configuration

```bash
cd ~/.config
ln -s ~/projects/aerospace-sketchybar-config/sketchybar sketchybar
```

##### Ghostty configuration

```bash
cd ~/.config
ln -s ~/projects/aerospace-sketchybar-config/ghostty ghostty
```

#### 3. Start services

AeroSpace will start automatically at login (configured in `.aerospace.toml`). SketchyBar will be launched automatically by AeroSpace.

To start manually:
```bash
brew services start sketchybar
aerospace reload-config
```

#### 4. Optional: Enable Dock autohide

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
├── install.sh                   # Automated installation script
├── README.md                    # This file
├── aerospace/
│   └── .aerospace.toml          # AeroSpace configuration
├── sketchybar/
│   ├── sketchybarrc             # SketchyBar main config
│   └── plugins/
│       ├── aerospace.sh         # Workspace indicators with app icons
│       ├── battery.sh           # Battery status
│       ├── clock.sh             # Date and time
│       ├── front_app.sh         # Active application name
│       ├── volume.sh            # Volume indicator
│       └── wifi.sh              # WiFi status
└── ghostty/
    └── config                   # Ghostty configuration with Tokyo Night theme
```

## Customization

### Modifying Workspaces

Edit the workspace shortcuts in `aerospace/.aerospace.toml`:
```toml
[mode.main.binding]
alt-1 = 'workspace 1'
# Add more as needed
```

### Changing Window Borders

Customize window border appearance in `aerospace/.aerospace.toml`:

```toml
after-startup-command = [
    'exec-and-forget sketchybar',
    'exec-and-forget borders active_color=0xff89b4fa inactive_color=0xff45475a width=8.0 hidpi=on'
]
```

Parameters:
- `active_color` - Color of the active window border (format: 0xAARRGGBB)
  - Current: `0xff89b4fa` (blue/cyan)
  - Popular alternatives: `0xfff38ba8` (red), `0xffa6e3a1` (green), `0xfff9e2af` (yellow)
- `inactive_color` - Color of inactive window borders
  - Current: `0xff45475a` (dark gray)
- `width` - Border thickness in pixels (current: 8.0)
- `hidpi` - Enable retina resolution rendering (`on` or `off`)

**Note about window corners**: Window rounded corners are controlled by macOS at the system level and cannot be easily removed on macOS 14+ (especially macOS 15/26+) due to Apple's security and UI integrity policies. JankyBorders only draws borders around windows - it doesn't modify the windows themselves.

After changing colors, reload AeroSpace config:
```bash
aerospace reload-config
```

### Changing Window Gaps

Adjust spacing between windows in `aerospace/.aerospace.toml`:

```toml
[gaps]
    inner.horizontal = 15  # Space between windows horizontally
    inner.vertical =   15  # Space between windows vertically
    outer.left =       15  # Space from screen edge (left)
    outer.bottom =     15  # Space from screen edge (bottom)
    outer.top = [{ monitor."Built-in" = 15 }, 55]  # Different for built-in vs external
    outer.right =      15  # Space from screen edge (right)
```

Reload config after changes:
```bash
aerospace reload-config
```

### Changing SketchyBar Appearance

Edit `sketchybar/sketchybarrc` to customize:
- Bar position and height
- Colors and transparency
- Font sizes
- Item spacing

### Adding Custom Plugins

Create new shell scripts in `sketchybar/plugins/` and add them to `sketchybarrc`.

### Customizing App Icons

To add or modify icons for applications in workspace indicators, edit the `get_app_icon()` function in `sketchybar/plugins/aerospace.sh`:

```bash
get_app_icon() {
    case "$1" in
        "Your App Name") echo "" ;;  # Add your app and icon
        # ... existing apps ...
    esac
}
```

**Finding app names**: Run `aerospace list-windows --all` to see the exact names AeroSpace uses for your applications.

**Finding icons**: Browse available icons at:
- [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet) - Search for icons and copy the character
- Icons from Font Awesome, Material Design Icons, Devicons, and more are included

After making changes, reload SketchyBar:
```bash
sketchybar --reload
```

### Customizing Ghostty Terminal

Edit `ghostty/config` to customize your terminal experience:

**Available Tokyo Night themes:**
- `TokyoNight` (default - balanced dark theme)
- `TokyoNight Day` (lighter variant)
- `TokyoNight Moon` (darker variant)
- `TokyoNight Night` (darkest variant)
- `TokyoNight Storm` (storm-themed colors)

**Example configuration:**
```ini
theme = TokyoNight
font-family = "Hack Nerd Font Mono Regular"
font-size = 14
term = xterm-256color
```

**Other customization options:**
- Change font size: `font-size = 16`
- Use different font: `font-family = "JetBrains Mono"`
- Enable/disable features: `clipboard-read = allow`, `mouse-shift-capture = true`

After making changes, restart Ghostty to apply the new configuration.

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

### Icons not displaying or showing as empty boxes
This usually means Nerd Fonts are not properly installed:
```bash
# Reinstall Hack Nerd Font
brew reinstall --cask font-hack-nerd-font

# Restart SketchyBar
brew services restart sketchybar
```

If specific icons are missing, they might not be in the current font. Try using alternative icons from the [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet).

### App icons not showing in workspaces
1. Check if AeroSpace recognizes your app:
   ```bash
   aerospace list-windows --all
   ```
2. Add the app name to `sketchybar/plugins/aerospace.sh` in the `get_app_icon()` function
3. Reload SketchyBar: `sketchybar --reload`

### Window borders not showing
If window borders are not visible:
```bash
# Check if borders is running
ps aux | grep borders

# Restart borders manually
killall borders
borders active_color=0xff89b4fa inactive_color=0xff45475a width=8.0 style=square &

# Or reload AeroSpace config (will restart borders automatically)
aerospace reload-config
```

### Ghostty colors not displaying
If Ghostty is not showing colors properly:
```bash
# Check if the symlink is correct
ls -la ~/.config/ghostty

# Verify the configuration file
cat ~/.config/ghostty/config

# Test colors in a new Ghostty window
echo -e "\033[31mRed\033[32mGreen\033[34mBlue\033[0m"
```

If colors still don't work, ensure the `term = xterm-256color` setting is in your `ghostty/config` file and restart Ghostty.

## Resources

- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/)
- [SketchyBar Documentation](https://felixkratz.github.io/SketchyBar/)
- [Ghostty Documentation](https://ghostty.org/docs) - Modern terminal emulator
- [JankyBorders](https://github.com/FelixKratz/JankyBorders) - Window borders for macOS
- [AeroSpace + SketchyBar Integration Guide](https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar)
- [Nerd Fonts](https://www.nerdfonts.com) - Icon fonts for developers
- [Nerd Fonts Cheat Sheet](https://www.nerdfonts.com/cheat-sheet) - Browse and search available icons

## License

This configuration is free to use and modify for personal use.


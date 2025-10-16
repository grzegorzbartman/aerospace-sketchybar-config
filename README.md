# AeroSpace Configuration

Configuration files for AeroSpace window manager with Ghostty terminal integration. This setup provides a tiling window management experience with keyboard shortcuts optimized to avoid conflicts with Polish characters.

## Features

- **AeroSpace**: Tiling window manager with customized keyboard shortcuts
- **Ghostty**: Modern terminal emulator with automatic theme switching
- **Quick app launchers**: Keyboard shortcuts for frequently used apps
- **Minimal gaps**: Clean 5px spacing between windows

## Quick Install (Automated)

**The easiest way to install everything!** Run the automated installation script:

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-config.git
cd aerospace-config
./install.sh
```

The `install.sh` script will:
- ✓ Check if Homebrew is installed
- ✓ Install AeroSpace and Ghostty
- ✓ Create symlinks for configuration files
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
brew install --cask ghostty nikitabobko/tap/aerospace
```

#### Individual Components

If you prefer to install components separately or need more information:

1. **AeroSpace** - [Installation guide](https://github.com/nikitabobko/AeroSpace)
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```

2. **Ghostty** - Modern terminal emulator with automatic theme switching

   Ghostty is a fast, feature-rich terminal emulator with excellent color support and theming capabilities. This configuration includes automatic theme switching based on macOS system appearance.

   ```bash
   brew install --cask ghostty
   ```

   After installation, create a symlink to the Ghostty configuration:
   ```bash
   cd ~/.config
   ln -s ~/projects/aerospace-config/ghostty ghostty
   ```

   The configuration includes:
   - **Automatic theme switching** - switches between light and dark themes based on macOS appearance
   - Cursor Dark theme (dark mode) - matches the Cursor editor look
   - GitHub Light Default theme (light mode) - clean and minimal
   - Proper terminal environment settings for full color support
   - Clipboard integration and mouse support

### Installation Steps

#### 1. Clone the repository

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-config.git
```

#### 2. Create symlinks

##### AeroSpace configuration

```bash
cd ~
ln -s ~/projects/aerospace-config/aerospace/.aerospace.toml .aerospace.toml
```

##### Ghostty configuration

```bash
cd ~/.config
ln -s ~/projects/aerospace-config/ghostty ghostty
```

#### 3. Start AeroSpace

AeroSpace will start automatically at login (configured in `.aerospace.toml`).

To start manually or reload config:
```bash
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
aerospace-config/
├── install.sh                   # Automated installation script
├── README.md                    # This file
├── aerospace/
│   └── .aerospace.toml          # AeroSpace configuration
└── ghostty/
    └── config                   # Ghostty configuration with automatic theme switching
```

## Customization

### Modifying Workspaces

Edit the workspace shortcuts in `aerospace/.aerospace.toml`:
```toml
[mode.main.binding]
alt-1 = 'workspace 1'
# Add more as needed
```

### Changing Window Gaps

Adjust spacing between windows in `aerospace/.aerospace.toml`:

```toml
[gaps]
    inner.horizontal = 5   # Space between windows horizontally
    inner.vertical =   5   # Space between windows vertically
    outer.left =       5   # Space from screen edge (left)
    outer.bottom =     5   # Space from screen edge (bottom)
    outer.top = [{ monitor."Built-in" = 5 }, 5]  # Different for built-in vs external
    outer.right =      5   # Space from screen edge (right)
```

Reload config after changes:
```bash
aerospace reload-config
```

### Customizing Ghostty Terminal

Edit `ghostty/config` to customize your terminal experience:

**Automatic Theme Switching (Default):**

The configuration automatically switches between light and dark themes based on macOS system appearance:

```ini
theme = light:GitHub Light Default,dark:Cursor Dark
```

This means:
- When macOS is in **light mode**: uses "GitHub Light Default" theme
- When macOS is in **dark mode**: uses "Cursor Dark" theme (matches Cursor editor)
- Changes automatically when you change system appearance - no restart needed!

**Popular theme combinations:**

```ini
# Cursor-like (default)
theme = light:GitHub Light Default,dark:Cursor Dark

# GitHub style
theme = light:GitHub Light Default,dark:GitHub Dark

# Tokyo Night
theme = light:TokyoNight Day,dark:TokyoNight

# Catppuccin
theme = light:Catppuccin Latte,dark:Catppuccin Mocha

# Dracula
theme = light:Atom One Light,dark:Dracula

# One theme family
theme = light:One Half Light,dark:One Half Dark
```

**Using a single theme (no auto-switching):**

If you prefer one theme for both light and dark modes:

```ini
theme = Cursor Dark
```

**Viewing all available themes:**

To see all available themes, run:
```bash
ghostty +list-themes
```

**Other customization options:**
- Change font size: `font-size = 16`
- Use different font: `font-family = "JetBrains Mono"`
- Enable/disable features: `clipboard-read = allow`, `mouse-shift-capture = true`

After making changes, Ghostty will automatically reload the configuration.

## Checking Workspaces

To see which applications are on which workspace, use the AeroSpace CLI:

```bash
# See all workspaces
aerospace list-workspaces --all

# See windows in a specific workspace
aerospace list-windows --workspace 1

# See all windows across all workspaces
aerospace list-windows --all
```

You can create an alias in `~/.zshrc` for quick access:

```bash
alias ws='aerospace list-windows --all'
```

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

### Advanced macOS Settings

Use the included `macos_settings.sh` script for easy configuration:

```bash
# Interactive mode (shows menu)
./macos_settings.sh

# Apply recommended settings
./macos_settings.sh --recommended

# Show current settings
./macos_settings.sh --show

# Get help
./macos_settings.sh --help
```

## Updating Configuration

Since configurations are symlinked, any changes made to the files in this repository will immediately affect your system. To sync changes across multiple computers:

```bash
cd ~/projects/aerospace-config
git pull origin main
aerospace reload-config
```

To push your improvements:

```bash
cd ~/projects/aerospace-config
git add .
git commit -m "Description of changes"
git push origin main
```

## Troubleshooting

### AeroSpace not responding
```bash
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

### Windows have wrong gaps after config change
Make sure to reload AeroSpace config:
```bash
aerospace reload-config
```

## Resources

- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/)
- [Ghostty Documentation](https://ghostty.org/docs) - Modern terminal emulator

## License

This configuration is free to use and modify for personal use.

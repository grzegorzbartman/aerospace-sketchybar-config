# AeroSpace Configuration

AeroSpace window manager with Ghostty terminal integration and SketchyBar status bar.

## Installation

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/aerospace-config.git
cd aerospace-config
./install.sh
```

## Usage

- **Reload config**: `./reload.sh`
- **macOS settings**: `./macos_settings.sh` (optional)

## Keyboard Shortcuts

**Window Management:**
- `Ctrl+Alt+H/J/K/L` - Focus window (left/down/up/right)
- `Alt+Shift+H/J/K/L` - Move window (left/down/up/right)
- `Alt+Minus/Equal` - Resize window
- `Alt+Slash` - Toggle horizontal/vertical layout
- `Alt+F` - Toggle floating/tiling mode

**Workspaces:**
- `Alt+1-9/0` - Switch to workspace 1-10
- `Alt+Shift+1-9/0` - Move window to workspace 1-10

**Quick Apps:**
- `Ctrl+Alt+B` - Safari
- `Ctrl+Alt+C` - Cursor
- `Ctrl+Alt+T` - iTerm
- `Ctrl+Alt+P` - PhpStorm

## Files

- `aerospace/.aerospace.toml` - AeroSpace config
- `ghostty/config` - Ghostty terminal config
- `sketchybar/sketchybarrc` - SketchyBar status bar config

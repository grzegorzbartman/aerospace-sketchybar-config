# Makaron - macOS Developer Configuration

Complete macOS development environment for PHP and Drupal developers with modern window management, terminal, and productivity tools.

## Perfect for

- **PHP Developers** - Optimized workflow for PHP development
- **Drupal Developers** - Tailored environment for Drupal projects
- **Web Developers** - Modern tools and efficient window management
- **Terminal Users** - Enhanced terminal experience with Ghostty
- **Productivity Enthusiasts** - Clean, distraction-free development setup

## Requirements

- macOS (tested on macOS 26)
- Homebrew installed
- Git

## Quick Installation

Install everything with one command:

```bash
curl -sL https://raw.githubusercontent.com/grzegorzbartman/makaron/main/install.sh | bash
```

This will:
- Clone the repository to `~/.local/share/makaron`
- Install Homebrew package manager
- Set up modern development environment (AeroSpace, SketchyBar, Ghostty)
- Configure system settings for optimal development workflow
- Install developer fonts and tools

## Manual Installation

If you prefer manual installation:

```bash
cd ~/projects
git clone https://github.com/grzegorzbartman/makaron.git
cd makaron
./install.sh
```

## Updates

To update your installation, simply run the install command again:

```bash
curl -sL https://raw.githubusercontent.com/grzegorzbartman/makaron/main/install.sh | bash
```

Or manually update:

```bash
cd ~/.local/share/makaron
git pull
```

## Usage

### Available Commands

After installation, you'll have access to these commands:

- **`makaron-update`** - Update configuration to latest version
- **`makaron-reload-aerospace-sketchybar`** - Reload all configurations
- **`makaron-migrate`** - Run pending migrations
- **`makaron-migration-status`** - Show migration status
- **`makaron-dev-add-migration`** - Create new migration (development)
- **`./install/macos_settings.sh`** - Apply macOS settings (optional)

### Manual Commands

- **Reload config**: `makaron-reload-aerospace-sketchybar`
- **macOS settings**: `./install/macos_settings.sh` (optional)

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

## Components

This development environment includes:

- **AeroSpace** - Modern tiling window manager for efficient coding workflow
- **SketchyBar** - Clean status bar with system information and development metrics
- **Ghostty** - Fast terminal emulator optimized for development
- **Borders** - Visual window borders for better focus
- **Nerd Fonts** - Developer-friendly fonts with icon support
- **macOS Settings** - Optimized system configuration for development

## Files

- `configs/aerospace/.aerospace.toml` - AeroSpace config
- `configs/ghostty/config` - Ghostty terminal config
- `configs/sketchybar/sketchybarrc` - SketchyBar status bar config
- `install/` - Modular installation scripts
  - `brew.sh` - Homebrew package manager installation
  - `ui/` - UI components (AeroSpace, SketchyBar, borders, fonts)
  - `tools/` - Development tools (Ghostty terminal)
  - `macos_settings.sh` - macOS system settings
  - `migrations.sh` - Migration system initialization
- `migrations/` - Database-style migrations for configuration updates
- `bin/` - Executable scripts
  - `makaron-migrate` - Run pending migrations
  - `makaron-migration-status` - Show migration status
  - `makaron-dev-add-migration` - Create new migration (development)

## Migration System

Makaron includes a migration system similar to database migrations (like Rails or Drupal). This allows for safe, incremental updates to your configuration.

### How it works

- Migrations are timestamped shell scripts in the `migrations/` directory
- Each migration runs only once per installation
- State is tracked in `~/.local/state/makaron/migrations/`
- Migrations run automatically during `makaron-update`

### Creating Migrations

For development, use the helper script:

```bash
makaron-dev-add-migration
```

This creates a new migration file with the current timestamp and opens it in your editor.

### Migration Status

Check which migrations have been applied:

```bash
makaron-migration-status
```

### Manual Migration

Run pending migrations manually:

```bash
makaron-migrate
```

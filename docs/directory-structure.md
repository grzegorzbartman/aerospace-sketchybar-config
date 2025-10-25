# Directory Structure

## Repository Layout

```
makaron/
├── assets/                       # Static assets (images, icons, etc.)
├── bin/                          # Executable scripts for user commands
│   ├── makaron-migrate                   # Run pending migrations
│   ├── makaron-migration-status          # Show migration status
│   ├── makaron-update                    # Update configuration from git
│   ├── makaron-reinstall                 # Complete reinstall
│   ├── makaron-reload-aerospace-sketchybar  # Reload UI configurations
│   ├── makaron-macos-config-reload       # Reload macOS settings
│   ├── makaron-switch-theme              # Helper to switch themes
│   ├── makaron-theme-tokyo-night         # Switch to Tokyo Night theme
│   ├── makaron-theme-catppuccin          # Switch to Catppuccin theme
│   └── makaron-theme-catppuccin-latte    # Switch to Catppuccin Latte theme
├── configs/                      # Configuration files
│   ├── aerospace/                # AeroSpace window manager configs
│   ├── sketchybar/              # SketchyBar status bar configs
│   │   ├── plugins/             # SketchyBar plugin scripts
│   │   │   ├── aerospace.sh
│   │   │   ├── battery.sh
│   │   │   ├── clock.sh
│   │   │   ├── cpu.sh
│   │   │   ├── front_app.sh
│   │   │   ├── memory.sh
│   │   │   ├── volume.sh
│   │   │   └── wifi.sh
│   │   └── sketchybarrc         # Main SketchyBar config
│   └── ghostty/                 # Ghostty terminal configs
│       └── config
├── docs/                         # Documentation for AI/LLM context
│   ├── directory-structure.md    # This file
│   └── migration-system.md       # Migration system documentation
├── install/                      # Installation scripts
│   ├── all.sh                   # Main installation orchestrator
│   ├── brew.sh                  # Homebrew package installation
│   ├── macos_settings.sh        # macOS system settings
│   ├── migrations.sh            # Initialize migration system
│   ├── tools/                   # Tool-specific installers
│   │   ├── all.sh
│   │   ├── composer.sh
│   │   ├── ddev.sh
│   │   └── ghostty.sh
│   └── ui/                      # UI component installers
│       ├── all.sh
│       ├── aerospace.sh
│       ├── borders.sh
│       ├── fonts.sh
│       └── sketchybar.sh
├── migrations/                   # Database-style migration scripts
│   ├── 1734567890.sh           # Example: Move configs to configs/
│   ├── 1761363175.sh           # Example: Fix PATH configuration
│   └── 1761364893.sh           # Example: Initialize theme system
├── themes/                       # Theme definitions (colors + wallpapers)
│   ├── tokyo-night/             # Default theme
│   │   ├── sketchybar.colors   # SketchyBar color definitions
│   │   ├── borders.colors      # Borders color definitions
│   │   └── backgrounds/        # Desktop backgrounds (original names)
│   │       └── 1-*.png
│   ├── catppuccin/              # Catppuccin Mocha theme
│   │   ├── sketchybar.colors
│   │   ├── borders.colors
│   │   └── backgrounds/
│   │       └── 1-*.png
│   └── catppuccin-latte/        # Catppuccin Latte (light) theme
│       ├── sketchybar.colors
│       ├── borders.colors
│       └── backgrounds/
│           └── 1-*.png
├── install.sh                    # Main installation entry point
└── README.md                     # User-facing documentation

## Installation Layout (User's System)

After installation, files are organized in the user's home directory:

```
$HOME/
├── .local/
│   ├── share/
│   │   └── makaron/            # Main installation directory (clone of repo)
│   │       ├── bin/            # User commands (added to PATH)
│   │       ├── configs/        # Configuration templates
│   │       ├── install/        # Installation scripts
│   │       ├── migrations/     # Migration scripts
│   │       ├── themes/         # Theme definitions
│   │       │   ├── tokyo-night/
│   │       │   ├── catppuccin/
│   │       │   └── catppuccin-latte/
│   │       └── current-theme -> themes/tokyo-night  # Symlink to active theme
│   └── state/
│       └── makaron/
│           └── migrations/     # Migration state tracking
│               ├── 1734567890.sh      # Empty file = completed
│               ├── 1761363175.sh      # Empty file = completed
│               ├── 1761364893.sh      # Empty file = completed
│               └── skipped/
│                   └── TIMESTAMP.sh   # Empty file = skipped by user
├── .config/
│   ├── sketchybar -> ~/.local/share/makaron/configs/sketchybar  # Symlink
│   └── ghostty -> ~/.local/share/makaron/configs/ghostty        # Symlink
├── .aerospace.toml -> ~/.local/share/makaron/configs/aerospace/aerospace.toml  # Symlink
├── .zshrc                      # Modified to include PATH
└── .bashrc                     # Modified to include PATH
```

## Key Paths

### Environment Variables

```bash
MAKARON_PATH="$HOME/.local/share/makaron"
MAKARON_INSTALL="$MAKARON_PATH/install"
MAKARON_INSTALL_LOG_FILE="$MAKARON_PATH/log/makaron-install.log"
MAKARON_MIGRATIONS_STATE_PATH="$HOME/.local/state/makaron/migrations"
```

### Important Locations

- **Repository clone**: `~/.local/share/makaron/`
- **User commands**: `~/.local/share/makaron/bin/` (in PATH)
- **Configuration files**: `~/.local/share/makaron/configs/`
- **Migration state**: `~/.local/state/makaron/migrations/`
- **Installation logs**: `~/.local/share/makaron/log/`

### Symlinks

Configurations are symlinked from the installation directory to their expected locations:

- `~/.aerospace.toml` → `~/.local/share/makaron/configs/aerospace/aerospace.toml`
- `~/.config/sketchybar` → `~/.local/share/makaron/configs/sketchybar`
- `~/.config/ghostty` → `~/.local/share/makaron/configs/ghostty`

## File Purposes

### `/bin/`
Executable scripts that users can run from anywhere (added to PATH). These provide the main interface for managing the Makaron installation.

### `/configs/`
Configuration files for various tools. These are the source of truth and are symlinked to their expected locations.

### `/docs/`
Documentation specifically for AI/LLM context in future conversations. Not user-facing documentation (that's in README.md).

### `/install/`
Scripts that run during installation to set up the system. These are modular and can be re-run individually.

### `/migrations/`
Timestamped shell scripts that perform incremental updates to existing installations. Similar to database migrations.

## Notes for AI/LLM

- **Symlinks**: Install scripts handle symlink creation and management. Detect and fix broken symlinks automatically.
- **PATH**: Added to `~/.zshrc` and `~/.bashrc` to make bin commands available.
- **State separation**: Configuration (in `.local/share`) is separate from state (in `.local/state`).
- **Git repository**: The entire `~/.local/share/makaron/` directory is a git repository that can be updated with `makaron-update`.

## Themes

Makaron includes a theme system that allows users to switch color schemes for SketchyBar, AeroSpace borders, and desktop wallpapers.

### Available Themes

1. **Tokyo Night** (default) - Dark theme with purple/blue accents
2. **Catppuccin Mocha** - Dark theme with pastel colors
3. **Catppuccin Latte** - Light theme with pastel colors

### Theme Structure

Each theme directory contains:
- `sketchybar.colors` - Color definitions for SketchyBar (bar, icons, workspaces)
- `borders.colors` - Color definitions for AeroSpace window borders
- `backgrounds/` - Directory with desktop wallpaper images (original filenames preserved for copyright)

### Theme Switching

Users can switch themes with:
```bash
makaron-theme-tokyo-night
makaron-theme-catppuccin
makaron-theme-catppuccin-latte
```

The system:
1. Updates `current-theme` symlink to point to the selected theme
2. Sets the desktop wallpaper
3. Reloads SketchyBar and AeroSpace configurations with new colors
4. Restarts borders with new colors

### Adding New Themes

To add a new theme:
1. Create a directory in `themes/` with the theme name
2. Add `sketchybar.colors` with color exports (see existing themes)
3. Add `borders.colors` with border color exports
4. Create `backgrounds/` directory and add wallpaper images (preserve original filenames)
5. Create a command script in `bin/makaron-theme-<name>` that calls `makaron-switch-theme <name>`
6. Make the command script executable


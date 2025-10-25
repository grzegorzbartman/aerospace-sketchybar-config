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
│   └── makaron-macos-config-reload       # Reload macOS settings
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
│   └── 1761363175.sh           # Example: Fix PATH configuration
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
│   │       └── migrations/     # Migration scripts
│   └── state/
│       └── makaron/
│           └── migrations/     # Migration state tracking
│               ├── 1734567890.sh      # Empty file = completed
│               ├── 1761363175.sh      # Empty file = completed
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


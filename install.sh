#!/bin/bash

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="aerospace-config"

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

# usage:
# log INFO "message"
# log ERROR "message"
# Output: [14:23:45] [INFO] Moja wiadomość
log() {
    echo "[$(date '+%H:%M:%S')] [$1] ${@:2}"
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if brew is installed
check_brew() {
    if ! command_exists brew; then
        log ERROR "Homebrew is not installed"
        log ERROR "Install Homebrew first: https://brew.sh"
        log ERROR "Run: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    log INFO "Homebrew found: $(brew --version | head -n 1)"
}

# Install AeroSpace
install_aerospace() {
    log INFO "Installing AeroSpace window manager"

    if command_exists aerospace; then
        log INFO "AeroSpace is already installed: $(aerospace --version 2>/dev/null || echo 'version unknown')"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Skipping AeroSpace installation"
            return
        fi
    fi

    brew install --cask nikitabobko/tap/aerospace || {
        log ERROR "Failed to install AeroSpace"
        exit 1
    }

    log INFO "AeroSpace installed successfully"
}

# Install Ghostty
install_ghostty() {
    log INFO "Installing Ghostty terminal emulator"

    if command_exists ghostty; then
        log INFO "Ghostty is already installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Skipping Ghostty installation"
            return
        fi
    fi

    brew install --cask ghostty || {
        log ERROR "Failed to install Ghostty"
        exit 1
    }

    log INFO "Ghostty installed successfully"
}

# Create symlink for AeroSpace config
setup_aerospace_config() {
    log INFO "Setting up AeroSpace configuration"

    local target="$HOME/.aerospace.toml"
    local source="$SCRIPT_DIR/aerospace/.aerospace.toml"

    if [ -f "$target" ] || [ -L "$target" ]; then
        log INFO "AeroSpace config already exists at $target"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local backup="$target.backup.$(date +%s)"
            mv "$target" "$backup"
            log INFO "Existing config backed up to: $backup"
        else
            log INFO "Skipping AeroSpace config setup"
            return
        fi
    fi

    ln -s "$source" "$target" || {
        log ERROR "Failed to create symlink for AeroSpace config"
        exit 1
    }

    log INFO "AeroSpace config symlinked: $target -> $source"
}

# Create symlink for Ghostty config
setup_ghostty_config() {
    log INFO "Setting up Ghostty configuration"

    local target="$HOME/.config/ghostty"
    local source="$SCRIPT_DIR/ghostty"

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    if [ -d "$target" ] || [ -L "$target" ]; then
        log INFO "Ghostty config already exists at $target"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local backup="$target.backup.$(date +%s)"
            mv "$target" "$backup"
            log INFO "Existing config backed up to: $backup"
        else
            log INFO "Skipping Ghostty config setup"
            return
        fi
    fi

    ln -s "$source" "$target" || {
        log ERROR "Failed to create symlink for Ghostty config"
        exit 1
    }

    log INFO "Ghostty config symlinked: $target -> $source"
}

# Reload AeroSpace config
reload_aerospace() {
    if command_exists aerospace; then
        log INFO "Reloading AeroSpace configuration"
        aerospace reload-config || {
            log ERROR "Failed to reload AeroSpace config"
            log INFO "You may need to restart AeroSpace manually"
        }
    fi
}

# Optional: Configure Dock autohide
configure_dock_autohide() {
    log INFO ""
    log INFO "Optional: Configure macOS Dock autohide for cleaner desktop"
    read -p "Do you want to enable Dock autohide? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log INFO "Enabling Dock autohide"
        defaults write com.apple.dock autohide -bool true

        read -p "Do you want to remove autohide delay (instant show/hide)? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Removing Dock autohide delay"
            defaults write com.apple.dock autohide-delay -float 0
        fi

        killall Dock
        log INFO "Dock configured successfully"
    else
        log INFO "Skipping Dock configuration"
    fi
}

# Show welcome message
show_welcome() {
    log INFO ""
    log INFO "╔════════════════════════════════════════════════════════════════╗"
    log INFO "║  AeroSpace Installation Complete!                              ║"
    log INFO "╚════════════════════════════════════════════════════════════════╝"
    log INFO ""
    log INFO "Installation Summary:"
    log INFO "  ✓ AeroSpace window manager installed"
    log INFO "  ✓ Ghostty terminal installed"
    log INFO "  ✓ Configuration files symlinked"
    log INFO ""
    log INFO "Next Steps:"
    log INFO "  1. AeroSpace should now be running"
    log INFO "  2. Review keyboard shortcuts in README.md"
    log INFO ""
    log INFO "Quick Start - Essential Shortcuts:"
    log INFO "  • Alt+1-9/0           - Switch to workspace 1-10"
    log INFO "  • Ctrl+Alt+H/J/K/L    - Focus window (left/down/up/right)"
    log INFO "  • Alt+Shift+H/J/K/L   - Move window"
    log INFO "  • Alt+Slash           - Toggle layout"
    log INFO "  • Alt+F               - Toggle floating/tiling"
    log INFO ""
    log INFO "Quick App Launchers:"
    log INFO "  • Ctrl+Alt+B          - Safari"
    log INFO "  • Ctrl+Alt+T          - iTerm"
    log INFO "  • Ctrl+Alt+C          - Cursor"
    log INFO ""
    log INFO "Configuration Files:"
    log INFO "  • AeroSpace: ~/.aerospace.toml"
    log INFO "  • Ghostty: ~/.config/ghostty/"
    log INFO ""
    log INFO "Troubleshooting:"
    log INFO "  • Reload AeroSpace:  aerospace reload-config"
    log INFO ""
    log INFO "Documentation:"
    log INFO "  • Full README: $SCRIPT_DIR/README.md"
    log INFO "  • AeroSpace: https://nikitabobko.github.io/AeroSpace/"
    log INFO "  • Ghostty: https://ghostty.org/"
    log INFO ""
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------

log INFO "╔════════════════════════════════════════════════════════════════╗"
log INFO "║  AeroSpace Configuration Installer                             ║"
log INFO "╚════════════════════════════════════════════════════════════════╝"
log INFO ""
log INFO "This script will install and configure:"
log INFO "  • AeroSpace - Tiling window manager"
log INFO "  • Ghostty - Modern terminal emulator"
log INFO ""
log INFO "Installation directory: $SCRIPT_DIR"
log INFO ""

# Check prerequisites
log INFO "Checking prerequisites..."
check_brew

# Install components
log INFO ""
log INFO "Step 1/5: Installing dependencies"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
install_aerospace
install_ghostty

# Setup configurations
log INFO ""
log INFO "Step 2/5: Setting up configuration files"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
setup_aerospace_config
setup_ghostty_config

log INFO ""
log INFO "Step 3/5: Reloading AeroSpace"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
reload_aerospace

log INFO ""
log INFO "Step 4/5: Optional Dock configuration"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
configure_dock_autohide

log INFO ""
log INFO "Step 5/5: Verifying installation"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log INFO "Checking installed components:"
command_exists aerospace && log INFO "  ✓ AeroSpace: $(aerospace --version 2>/dev/null || echo 'installed')" || log ERROR "  ✗ AeroSpace not found"
command_exists ghostty && log INFO "  ✓ Ghostty: installed" || log ERROR "  ✗ Ghostty not found"
[ -f "$HOME/.aerospace.toml" ] && log INFO "  ✓ AeroSpace config: linked" || log ERROR "  ✗ AeroSpace config not found"
[ -d "$HOME/.config/ghostty" ] && log INFO "  ✓ Ghostty config: linked" || log ERROR "  ✗ Ghostty config not found"

log INFO ""
log INFO "Installation complete!"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

show_welcome

log INFO "Installation finished at: $(date '+%Y-%m-%d %H:%M:%S')"
log INFO ""

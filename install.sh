#!/bin/bash

#------------------------------------------------------------------------------
# Configuration
#------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="aerospace-sketchybar-config"

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

# Install SketchyBar
install_sketchybar() {
    log INFO "Installing SketchyBar status bar"

    if command_exists sketchybar; then
        log INFO "SketchyBar is already installed: $(sketchybar --version 2>/dev/null || echo 'version unknown')"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Skipping SketchyBar installation"
            return
        fi
    fi

    # Add FelixKratz tap if not already added
    brew tap FelixKratz/formulae 2>/dev/null || log INFO "FelixKratz/formulae tap already added"

    brew install sketchybar || {
        log ERROR "Failed to install SketchyBar"
        exit 1
    }

    log INFO "SketchyBar installed successfully"
}

# Install JankyBorders
install_borders() {
    log INFO "Installing JankyBorders (window borders)"

    if command_exists borders; then
        log INFO "JankyBorders is already installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Skipping JankyBorders installation"
            return
        fi
    fi

    # Tap should already be added from SketchyBar installation
    brew tap FelixKratz/formulae 2>/dev/null || log INFO "FelixKratz/formulae tap already added"

    brew install borders || {
        log ERROR "Failed to install JankyBorders"
        exit 1
    }

    log INFO "JankyBorders installed successfully"
}

# Install Nerd Font
install_nerd_font() {
    log INFO "Installing Hack Nerd Font (required for app icons)"

    # Check if font is already installed
    if ls ~/Library/Fonts/*Hack*Nerd* &>/dev/null || ls /Library/Fonts/*Hack*Nerd* &>/dev/null; then
        log INFO "Hack Nerd Font appears to be already installed"
        read -p "Do you want to reinstall? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Skipping Nerd Font installation"
            return
        fi
    fi

    brew install --cask font-hack-nerd-font || {
        log ERROR "Failed to install Hack Nerd Font"
        exit 1
    }

    log INFO "Hack Nerd Font installed successfully"
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

# Create symlink for SketchyBar config
setup_sketchybar_config() {
    log INFO "Setting up SketchyBar configuration"

    local target="$HOME/.config/sketchybar"
    local source="$SCRIPT_DIR/sketchybar"

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    if [ -d "$target" ] || [ -L "$target" ]; then
        log INFO "SketchyBar config already exists at $target"
        read -p "Do you want to backup and replace it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local backup="$target.backup.$(date +%s)"
            mv "$target" "$backup"
            log INFO "Existing config backed up to: $backup"
        else
            log INFO "Skipping SketchyBar config setup"
            return
        fi
    fi

    ln -s "$source" "$target" || {
        log ERROR "Failed to create symlink for SketchyBar config"
        exit 1
    }

    log INFO "SketchyBar config symlinked: $target -> $source"
}

# Make plugin scripts executable
setup_plugin_permissions() {
    log INFO "Setting executable permissions for plugin scripts"

    chmod +x "$SCRIPT_DIR/sketchybar/plugins/"*.sh || {
        log ERROR "Failed to set executable permissions"
        exit 1
    }

    log INFO "Plugin scripts are now executable"
}

# Start services
start_services() {
    log INFO "Starting services"

    # Stop services if already running
    if brew services list | grep -q "sketchybar.*started"; then
        log INFO "Stopping existing SketchyBar service"
        brew services stop sketchybar
        sleep 1
    fi

    # Start SketchyBar
    log INFO "Starting SketchyBar"
    brew services start sketchybar || {
        log ERROR "Failed to start SketchyBar"
        exit 1
    }

    # Start JankyBorders
    log INFO "Starting JankyBorders (window borders)"
    brew services start borders || {
        log ERROR "Failed to start JankyBorders"
        exit 1
    }

    # Reload AeroSpace config
    if command_exists aerospace; then
        log INFO "Reloading AeroSpace configuration"
        aerospace reload-config || {
            log ERROR "Failed to reload AeroSpace config"
            log INFO "You may need to restart AeroSpace manually"
        }
    fi

    log INFO "Services started successfully"
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
    log INFO "║  AeroSpace + SketchyBar Installation Complete!                ║"
    log INFO "╚════════════════════════════════════════════════════════════════╝"
    log INFO ""
    log INFO "Installation Summary:"
    log INFO "  ✓ AeroSpace window manager installed"
    log INFO "  ✓ SketchyBar status bar installed"
    log INFO "  ✓ JankyBorders (window borders) installed"
    log INFO "  ✓ Hack Nerd Font installed"
    log INFO "  ✓ Configuration files symlinked"
    log INFO "  ✓ Services started"
    log INFO ""
    log INFO "Next Steps:"
    log INFO "  1. AeroSpace should now be running with window borders"
    log INFO "  2. SketchyBar should be visible at the top of your screen"
    log INFO "  3. Review keyboard shortcuts in README.md"
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
    log INFO "  • SketchyBar: ~/.config/sketchybar/"
    log INFO ""
    log INFO "Troubleshooting:"
    log INFO "  • Reload AeroSpace:  aerospace reload-config"
    log INFO "  • Restart SketchyBar: brew services restart sketchybar"
    log INFO "  • View logs:         brew services info sketchybar"
    log INFO ""
    log INFO "Documentation:"
    log INFO "  • Full README: $SCRIPT_DIR/README.md"
    log INFO "  • AeroSpace: https://nikitabobko.github.io/AeroSpace/"
    log INFO "  • SketchyBar: https://felixkratz.github.io/SketchyBar/"
    log INFO ""
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------

log INFO "╔════════════════════════════════════════════════════════════════╗"
log INFO "║  AeroSpace + SketchyBar Configuration Installer                ║"
log INFO "╚════════════════════════════════════════════════════════════════╝"
log INFO ""
log INFO "This script will install and configure:"
log INFO "  • AeroSpace - Tiling window manager"
log INFO "  • SketchyBar - Status bar with workspace indicators"
log INFO "  • JankyBorders - Visual window borders"
log INFO "  • Hack Nerd Font - Required for app icons"
log INFO ""
log INFO "Installation directory: $SCRIPT_DIR"
log INFO ""

# Check prerequisites
log INFO "Checking prerequisites..."
check_brew

# Install components
log INFO ""
log INFO "Step 1/7: Installing dependencies"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
install_aerospace
install_sketchybar
install_borders
install_nerd_font

# Setup configurations
log INFO ""
log INFO "Step 2/7: Setting up configuration files"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
setup_aerospace_config
setup_sketchybar_config

log INFO ""
log INFO "Step 3/7: Setting up plugin permissions"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
setup_plugin_permissions

log INFO ""
log INFO "Step 4/7: Starting services"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
start_services

log INFO ""
log INFO "Step 5/7: Optional Dock configuration"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
configure_dock_autohide

log INFO ""
log INFO "Step 6/7: Verifying installation"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log INFO "Checking installed components:"
command_exists aerospace && log INFO "  ✓ AeroSpace: $(aerospace --version 2>/dev/null || echo 'installed')" || log ERROR "  ✗ AeroSpace not found"
command_exists sketchybar && log INFO "  ✓ SketchyBar: installed" || log ERROR "  ✗ SketchyBar not found"
command_exists borders && log INFO "  ✓ JankyBorders: installed" || log ERROR "  ✗ JankyBorders not found"
[ -f "$HOME/.aerospace.toml" ] && log INFO "  ✓ AeroSpace config: linked" || log ERROR "  ✗ AeroSpace config not found"
[ -d "$HOME/.config/sketchybar" ] && log INFO "  ✓ SketchyBar config: linked" || log ERROR "  ✗ SketchyBar config not found"

log INFO ""
log INFO "Step 7/7: Installation complete!"
log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

show_welcome

log INFO "Installation finished at: $(date '+%Y-%m-%d %H:%M:%S')"
log INFO ""


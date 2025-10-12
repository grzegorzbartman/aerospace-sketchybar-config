#!/bin/bash

#------------------------------------------------------------------------------
# macOS Settings Configuration Script
# Configures macOS settings for optimal use with AeroSpace and SketchyBar
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

# usage:
# log INFO "message"
# log ERROR "message"
# Output: [14:23:45] [INFO] Message
log() {
    echo "[$(date '+%H:%M:%S')] [$1] ${@:2}"
}

# Enable Dock autohide
enable_dock_autohide() {
    log INFO "Enabling Dock autohide"
    defaults write com.apple.dock autohide -bool true && killall Dock
    log INFO "Dock autohide enabled"
}

# Disable Dock autohide
disable_dock_autohide() {
    log INFO "Disabling Dock autohide"
    defaults write com.apple.dock autohide -bool false && killall Dock
    log INFO "Dock autohide disabled"
}

# Remove Dock autohide delay (instant show/hide)
remove_dock_autohide_delay() {
    log INFO "Removing Dock autohide delay (instant show/hide)"
    defaults write com.apple.dock autohide-delay -float 0 && killall Dock
    log INFO "Dock autohide delay removed"
}

# Restore default Dock autohide delay
restore_dock_autohide_delay() {
    log INFO "Restoring default Dock autohide delay"
    defaults delete com.apple.dock autohide-delay && killall Dock
    log INFO "Dock autohide delay restored to default"
}

# Enable Mission Control grouping by application
enable_mission_control_grouping() {
    log INFO "Enabling Mission Control grouping by application"
    defaults write com.apple.dock expose-group-apps -bool true && killall Dock
    log INFO "Mission Control will now group windows by application"
}

# Disable Mission Control grouping by application
disable_mission_control_grouping() {
    log INFO "Disabling Mission Control grouping by application"
    defaults write com.apple.dock expose-group-apps -bool false && killall Dock
    log INFO "Mission Control grouping disabled"
}

# Disable menu bar transparency (make it opaque)
# Alternative manual methods for macOS 26 (Tahoe) if terminal command doesn't work:
# 1. System Settings > Accessibility > Display > Reduce Transparency (toggle on)
# 2. System Settings > Menu Bar > Show Menu Bar Background (turn on)
disable_menubar_transparency() {
    log INFO "Disabling menu bar transparency (making it opaque)"
    defaults write com.apple.universalaccess reduceTransparency -bool true
    log INFO "Menu bar transparency disabled"
    log INFO "Note: You may need to log out and log back in for changes to take effect"
    log INFO ""
    log INFO "If the terminal command doesn't work, you can set it manually:"
    log INFO "  Method 1: System Settings > Accessibility > Display > Reduce Transparency (toggle on)"
    log INFO "  Method 2: System Settings > Menu Bar > Show Menu Bar Background (turn on)"
}

# Enable menu bar transparency (make it translucent)
# Alternative manual methods for macOS 26 (Tahoe) if terminal command doesn't work:
# 1. System Settings > Accessibility > Display > Reduce Transparency (toggle off)
# 2. System Settings > Menu Bar > Show Menu Bar Background (turn off)
enable_menubar_transparency() {
    log INFO "Enabling menu bar transparency (making it translucent)"
    defaults write com.apple.universalaccess reduceTransparency -bool false
    log INFO "Menu bar transparency enabled"
    log INFO "Note: You may need to log out and log back in for changes to take effect"
    log INFO ""
    log INFO "If the terminal command doesn't work, you can set it manually:"
    log INFO "  Method 1: System Settings > Accessibility > Display > Reduce Transparency (toggle off)"
    log INFO "  Method 2: System Settings > Menu Bar > Show Menu Bar Background (turn off)"
}

# Show current settings
show_current_settings() {
    log INFO ""
    log INFO "Current macOS Settings:"
    log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local autohide=$(defaults read com.apple.dock autohide 2>/dev/null || echo "0")
    local delay=$(defaults read com.apple.dock autohide-delay 2>/dev/null || echo "default")
    local expose_group=$(defaults read com.apple.dock expose-group-apps 2>/dev/null || echo "0")
    local reduce_transparency=$(defaults read com.apple.universalaccess reduceTransparency 2>/dev/null || echo "0")

    if [ "$autohide" = "1" ]; then
        log INFO "  Dock Autohide: ✓ Enabled"
    else
        log INFO "  Dock Autohide: ✗ Disabled"
    fi

    if [ "$delay" = "0" ]; then
        log INFO "  Dock Autohide Delay: ✓ Removed (instant)"
    elif [ "$delay" = "default" ]; then
        log INFO "  Dock Autohide Delay: Default"
    else
        log INFO "  Dock Autohide Delay: ${delay}s"
    fi

    if [ "$expose_group" = "1" ]; then
        log INFO "  Mission Control Grouping: ✓ Enabled"
    else
        log INFO "  Mission Control Grouping: ✗ Disabled"
    fi

    if [ "$reduce_transparency" = "1" ]; then
        log INFO "  Menu Bar Transparency: ✓ Disabled (opaque)"
    else
        log INFO "  Menu Bar Transparency: ✗ Enabled (translucent)"
    fi

    log INFO ""
}

# Apply recommended settings
apply_recommended_settings() {
    log INFO ""
    log INFO "Applying recommended settings for AeroSpace + SketchyBar"
    log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    enable_dock_autohide
    sleep 1
    remove_dock_autohide_delay
    sleep 1
    enable_mission_control_grouping
    sleep 1
    disable_menubar_transparency

    log INFO ""
    log INFO "✓ Recommended settings applied successfully"
    log INFO "Note: You may need to log out and log back in for all changes to take effect"
}

# Show interactive menu
show_menu() {
    log INFO ""
    log INFO "╔════════════════════════════════════════════════════════════════╗"
    log INFO "║  macOS Settings Configuration                                  ║"
    log INFO "╚════════════════════════════════════════════════════════════════╝"
    log INFO ""
    log INFO "Choose an option:"
    log INFO ""
    log INFO "  1) Apply recommended settings (Dock + Mission Control + Menu Bar)"
    log INFO "  2) Enable Dock autohide"
    log INFO "  3) Disable Dock autohide"
    log INFO "  4) Remove Dock autohide delay (instant)"
    log INFO "  5) Restore default Dock autohide delay"
    log INFO "  6) Enable Mission Control grouping by application"
    log INFO "  7) Disable Mission Control grouping by application"
    log INFO "  8) Disable menu bar transparency (make opaque)"
    log INFO "  9) Enable menu bar transparency (make translucent)"
    log INFO " 10) Show current settings"
    log INFO " 11) Exit"
    log INFO ""
    read -p "Enter your choice (1-11): " choice

    case $choice in
        1)
            apply_recommended_settings
            ;;
        2)
            enable_dock_autohide
            ;;
        3)
            disable_dock_autohide
            ;;
        4)
            remove_dock_autohide_delay
            ;;
        5)
            restore_dock_autohide_delay
            ;;
        6)
            enable_mission_control_grouping
            ;;
        7)
            disable_mission_control_grouping
            ;;
        8)
            disable_menubar_transparency
            ;;
        9)
            enable_menubar_transparency
            ;;
        10)
            show_current_settings
            ;;
        11)
            log INFO "Exiting..."
            exit 0
            ;;
        *)
            log ERROR "Invalid option. Please choose 1-11."
            ;;
    esac
}

#------------------------------------------------------------------------------
# Main
#------------------------------------------------------------------------------

# Check if running with arguments
if [ $# -eq 0 ]; then
    # Interactive mode
    while true; do
        show_menu
        log INFO ""
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log INFO "Goodbye!"
            exit 0
        fi
    done
else
    # Command-line mode
    case "$1" in
        --recommended)
            apply_recommended_settings
            ;;
        --show)
            show_current_settings
            ;;
        --dock-autohide-on)
            enable_dock_autohide
            ;;
        --dock-autohide-off)
            disable_dock_autohide
            ;;
        --dock-delay-remove)
            remove_dock_autohide_delay
            ;;
        --dock-delay-restore)
            restore_dock_autohide_delay
            ;;
        --mission-control-group-on)
            enable_mission_control_grouping
            ;;
        --mission-control-group-off)
            disable_mission_control_grouping
            ;;
        --menubar-transparency-off)
            disable_menubar_transparency
            ;;
        --menubar-transparency-on)
            enable_menubar_transparency
            ;;
        --help|-h)
            log INFO "Usage: $0 [OPTION]"
            log INFO ""
            log INFO "Options:"
            log INFO "  --recommended                   Apply recommended settings"
            log INFO "  --show                          Show current settings"
            log INFO "  --dock-autohide-on              Enable Dock autohide"
            log INFO "  --dock-autohide-off             Disable Dock autohide"
            log INFO "  --dock-delay-remove             Remove Dock autohide delay"
            log INFO "  --dock-delay-restore            Restore default Dock autohide delay"
            log INFO "  --mission-control-group-on      Enable Mission Control grouping"
            log INFO "  --mission-control-group-off     Disable Mission Control grouping"
            log INFO "  --menubar-transparency-off      Disable menu bar transparency (opaque)"
            log INFO "  --menubar-transparency-on       Enable menu bar transparency (translucent)"
            log INFO "  -h, --help                      Show this help message"
            log INFO ""
            log INFO "Run without arguments for interactive menu."
            ;;
        *)
            log ERROR "Unknown option: $1"
            log INFO "Use --help for usage information"
            exit 1
            ;;
    esac
fi


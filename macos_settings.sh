#!/bin/bash

#------------------------------------------------------------------------------
# macOS Settings Configuration Script
# Configures macOS settings for optimal use with AeroSpace
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

# Show current settings
show_current_settings() {
    log INFO ""
    log INFO "Current macOS Settings:"
    log INFO "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    local expose_group=$(defaults read com.apple.dock expose-group-apps 2>/dev/null || echo "0")

    if [ "$expose_group" = "1" ]; then
        log INFO "  Mission Control Grouping: ✓ Enabled (Recommended for AeroSpace)"
    else
        log INFO "  Mission Control Grouping: ✗ Disabled"
    fi

    log INFO ""
}

# Show interactive menu
show_menu() {
    log INFO ""
    log INFO "╔════════════════════════════════════════════════════════════════╗"
    log INFO "║  macOS Settings Configuration for AeroSpace                   ║"
    log INFO "╚════════════════════════════════════════════════════════════════╝"
    log INFO ""
    log INFO "Choose an option:"
    log INFO ""
    log INFO "  1) Enable Mission Control grouping (Recommended)"
    log INFO "  2) Disable Mission Control grouping"
    log INFO "  3) Show current settings"
    log INFO "  4) Exit"
    log INFO ""
    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            enable_mission_control_grouping
            ;;
        2)
            disable_mission_control_grouping
            ;;
        3)
            show_current_settings
            ;;
        4)
            log INFO "Exiting..."
            exit 0
            ;;
        *)
            log ERROR "Invalid option. Please choose 1-4."
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
        --enable-mission-control-grouping)
            enable_mission_control_grouping
            ;;
        --disable-mission-control-grouping)
            disable_mission_control_grouping
            ;;
        --show)
            show_current_settings
            ;;
        --help|-h)
            log INFO "Usage: $0 [OPTION]"
            log INFO ""
            log INFO "Mission Control Fix for AeroSpace:"
            log INFO "  AeroSpace may cause Mission Control to display windows too small."
            log INFO "  Enabling grouping by application fixes this issue."
            log INFO ""
            log INFO "Options:"
            log INFO "  --enable-mission-control-grouping   Enable grouping (Recommended)"
            log INFO "  --disable-mission-control-grouping  Disable grouping"
            log INFO "  --show                              Show current settings"
            log INFO "  -h, --help                          Show this help message"
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

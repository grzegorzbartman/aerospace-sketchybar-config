#!/bin/bash

# Migration: Enable Dock autohide, Menu Bar autohide, and Reduce Transparency
# Applies accessibility and UI settings for better AeroSpace integration

set -e

error_exit() {
  echo -e "\033[31mERROR: Migration failed! Manual intervention required.\033[0m" >&2
  exit 1
}

trap error_exit ERR

echo "Running migration: Enable Dock autohide, Menu Bar autohide, and Reduce Transparency"

# Check if settings are already applied (idempotent)
DOCK_AUTOHIDE=$(defaults read com.apple.dock autohide 2>/dev/null || echo "0")
MENUBAR_AUTOHIDE=$(defaults read NSGlobalDomain _HIHideMenuBar 2>/dev/null || echo "0")
REDUCE_TRANSPARENCY=$(defaults read com.apple.universalaccess reduceTransparency 2>/dev/null || echo "0")

if [ "$DOCK_AUTOHIDE" = "1" ] && [ "$MENUBAR_AUTOHIDE" = "1" ] && [ "$REDUCE_TRANSPARENCY" = "1" ]; then
    echo "Settings already applied, skipping"
    exit 0
fi

# Apply Dock autohide
echo "Enabling Dock autohide..."
defaults write com.apple.dock autohide -bool true

# Apply Menu Bar autohide (always)
echo "Enabling Menu Bar autohide (always)..."
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Apply Reduce Transparency
echo "Enabling Reduce Transparency..."
defaults write com.apple.universalaccess reduceTransparency -bool true

# Restart Dock and SystemUIServer to apply changes
echo "Applying changes..."
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "Migration completed successfully"
echo "Note: You may need to log out and log back in for Menu Bar changes to take full effect"


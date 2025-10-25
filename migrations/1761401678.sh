#!/bin/bash

# Migration: Install SwipeAeroSpace for 3-finger swipe workspace switching
# Adds SwipeAeroSpace to enhance AeroSpace with gesture-based workspace navigation

echo "Running migration: Install SwipeAeroSpace"

# Set MAKARON_PATH if not already set
MAKARON_PATH="${MAKARON_PATH:-$HOME/.local/share/makaron}"

# Check if SwipeAeroSpace is already installed (idempotent)
if brew list --cask mediosz/tap/swipeaerospace &> /dev/null; then
    echo "SwipeAeroSpace already installed, skipping"
    exit 0
fi

# Run the SwipeAeroSpace installation script
source "$MAKARON_PATH/install/ui/swipeaerospace.sh"

echo "Migration completed"
echo ""
echo "You can now use 3-finger swipe to switch between AeroSpace workspaces!"
echo ""


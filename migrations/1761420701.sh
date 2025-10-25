#!/bin/bash

# Migration: Add app menu to SketchyBar
# Installs jq dependency and enables clickable menu bar

set -e

echo "Adding app menu feature to SketchyBar..."

if ! command -v jq &>/dev/null; then
    echo "Installing jq (required for app menu)..."
    brew install jq
    echo "✓ jq installed"
else
    echo "✓ jq already installed"
fi

echo "Reloading SketchyBar..."
sketchybar --reload 2>/dev/null || true

echo ""
echo "✓ App menu added successfully!"
echo "  Click the  icon in SketchyBar to access your app's menu bar"
echo ""
echo "⚠ IMPORTANT: App menu requires Accessibility permissions"
echo "  If menu doesn't work, enable permissions in:"
echo "  System Settings → Privacy & Security → Accessibility"
echo "  Add: SketchyBar and osascript"


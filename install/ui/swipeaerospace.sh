#!/bin/bash

# Install SwipeAeroSpace
if ! brew list --cask mediosz/tap/swipeaerospace &> /dev/null; then
    echo "Installing SwipeAeroSpace..."
    brew install --cask mediosz/tap/swipeaerospace
fi

# Check accessibility permissions
check_accessibility() {
    local app_path="/Applications/SwipeAeroSpace.app"

    if [ ! -d "$app_path" ]; then
        echo "⚠️  SwipeAeroSpace.app not found at $app_path"
        return 1
    fi

    # Check if app has accessibility permissions using tccutil (best effort)
    if command -v tccutil &> /dev/null; then
        # Note: This check might not work on all macOS versions
        if ! tccutil check com.apple.universalaccess "$app_path" &> /dev/null; then
            return 1
        fi
    fi

    return 0
}

# Inform user about accessibility permissions
if ! check_accessibility; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  IMPORTANT: Accessibility Permissions Required"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "SwipeAeroSpace needs accessibility permissions to work."
    echo ""
    echo "Please grant permission in:"
    echo "  System Settings → Privacy & Security → Accessibility"
    echo ""
    echo "Opening System Settings for you..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Try to open System Settings to the Accessibility page
    open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" 2>/dev/null || \
    open "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension" 2>/dev/null || \
    open -b com.apple.systempreferences 2>/dev/null

    sleep 2
fi

# Launch SwipeAeroSpace
if [ -d "/Applications/SwipeAeroSpace.app" ]; then
    echo "Launching SwipeAeroSpace..."
    open -a SwipeAeroSpace

    # Setup SwipeAeroSpace to start at login
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/SwipeAeroSpace.app", hidden:false}' 2>/dev/null || {
        echo "Note: Could not add SwipeAeroSpace to login items automatically."
        echo "You can add it manually: System Settings → General → Login Items"
    }
else
    echo "⚠️  SwipeAeroSpace.app not found. Installation may have failed."
fi


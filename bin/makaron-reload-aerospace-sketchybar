#!/bin/bash
# Quick reload script for AeroSpace configuration

# Check if AeroSpace is running, start if not
if ! pgrep -f "AeroSpace" > /dev/null; then
    echo "AeroSpace not running, starting..."
    open -a AeroSpace
    sleep 2  # Give it time to start
fi

# Check if SketchyBar is running, start if not
if ! pgrep -f "sketchybar" > /dev/null; then
    echo "SketchyBar not running, starting..."
    brew services start sketchybar
    sleep 2  # Give it time to start
fi

# Now reload the configurations
aerospace reload-config
sketchybar --reload

# Check if borders command exists before trying to use it
if command -v borders &> /dev/null; then
    # Check if borders process is running before trying to kill it
    if pgrep -f "borders" > /dev/null; then
        pkill -f borders 2>/dev/null || true
        sleep 0.5  # Give it time to terminate
    fi
    borders active_color=0xff7aa2f7 inactive_color=0xff3b4261 width=2.0 &
    echo "Borders started successfully"
else
    echo "Borders command not found, skipping..."
fi

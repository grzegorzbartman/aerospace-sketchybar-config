#!/bin/bash

# Source all UI installation scripts
source "$MAKARON_PATH/install/ui/fonts.sh"
source "$MAKARON_PATH/install/ui/borders.sh"
source "$MAKARON_PATH/install/ui/aerospace.sh"
source "$MAKARON_PATH/install/ui/sketchybar.sh"

# Initialize default theme (tokyo-night)
echo "Setting up default theme (Tokyo Night)..."
if [ ! -L "$MAKARON_PATH/current-theme" ]; then
    ln -s "$MAKARON_PATH/themes/tokyo-night" "$MAKARON_PATH/current-theme"
    echo "Default theme set to Tokyo Night"
fi


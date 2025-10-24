#!/bin/bash

# Install SketchyBar
if ! command -v sketchybar &> /dev/null; then
    brew tap FelixKratz/formulae
    brew install sketchybar
fi

# Setup SketchyBar config
if [ ! -L "$HOME/.config/sketchybar" ] && [ ! -d "$HOME/.config/sketchybar" ]; then
    ln -s "$MAKARON_PATH/sketchybar" "$HOME/.config/sketchybar"
else
    read -p "SketchyBar config exists. Overwrite? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.config/sketchybar"
        ln -s "$MAKARON_PATH/sketchybar" "$HOME/.config/sketchybar"
    fi
fi

# Start SketchyBar service
brew services start sketchybar

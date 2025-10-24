#!/bin/bash

# Install Ghostty
if ! command -v ghostty &> /dev/null; then
    brew install --cask ghostty
fi

# Setup Ghostty config
mkdir -p "$HOME/.config"
if [ ! -L "$HOME/.config/ghostty" ] && [ ! -d "$HOME/.config/ghostty" ]; then
    ln -s "$MAKARON_PATH/configs/ghostty" "$HOME/.config/ghostty"
else
    # Check if symlink points to wrong location
    if [ -L "$HOME/.config/ghostty" ]; then
        current_target=$(readlink "$HOME/.config/ghostty")
        if [[ "$current_target" != "$MAKARON_PATH/configs/ghostty" ]]; then
            echo "Fixing Ghostty symlink to point to new location..."
            rm "$HOME/.config/ghostty"
            ln -s "$MAKARON_PATH/configs/ghostty" "$HOME/.config/ghostty"
        fi
    else
        read -p "Ghostty config exists. Overwrite? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.config/ghostty"
            ln -s "$MAKARON_PATH/configs/ghostty" "$HOME/.config/ghostty"
        fi
    fi
fi

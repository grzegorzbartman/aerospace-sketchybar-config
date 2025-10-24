#!/bin/bash

# Install Ghostty
if ! command -v ghostty &> /dev/null; then
    brew install --cask ghostty
fi

# Setup Ghostty config
mkdir -p "$HOME/.config"
if [ ! -L "$HOME/.config/ghostty" ] && [ ! -d "$HOME/.config/ghostty" ]; then
    ln -s "$MAKARON_PATH/ghostty" "$HOME/.config/ghostty"
else
    read -p "Ghostty config exists. Overwrite? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.config/ghostty"
        ln -s "$MAKARON_PATH/ghostty" "$HOME/.config/ghostty"
    fi
fi

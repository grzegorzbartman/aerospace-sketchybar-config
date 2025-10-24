#!/bin/bash

# Install AeroSpace
if ! command -v aerospace &> /dev/null; then
    brew install --cask nikitabobko/tap/aerospace
fi

# Setup AeroSpace config
if [ ! -L "$HOME/.aerospace.toml" ] && [ ! -f "$HOME/.aerospace.toml" ]; then
    ln -s "$MAKARON_PATH/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
else
    read -p "AeroSpace config exists. Overwrite? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$HOME/.aerospace.toml"
        ln -s "$MAKARON_PATH/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
    fi
fi

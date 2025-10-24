#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install AeroSpace
if ! command -v aerospace &> /dev/null; then
    brew install --cask nikitabobko/tap/aerospace
fi

# Install Ghostty
if ! command -v ghostty &> /dev/null; then
    brew install --cask ghostty
fi

# Install Nerd Fonts
echo "Installing popular Nerd Fonts..."
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-source-code-pro-nerd-font

# Install borders (window border utility)
if ! command -v borders &> /dev/null; then
    echo "Installing borders..."
    brew tap FelixKratz/formulae
    brew install borders
else
    echo "Borders already installed"
fi

# Setup AeroSpace config
if [ ! -L "$HOME/.aerospace.toml" ] && [ ! -f "$HOME/.aerospace.toml" ]; then
    ln -s "$SCRIPT_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
    echo "AeroSpace config linked successfully"
else
    echo "AeroSpace config already exists, skipping..."
fi

# Setup Ghostty config
mkdir -p "$HOME/.config"
if [ ! -L "$HOME/.config/ghostty" ] && [ ! -d "$HOME/.config/ghostty" ]; then
    ln -s "$SCRIPT_DIR/ghostty" "$HOME/.config/ghostty"
    echo "Ghostty config linked successfully"
else
    echo "Ghostty config already exists, skipping..."
fi

# Reload configurations
./reload.sh

#!/bin/bash

# Migration: Fix PATH configuration in shell config files
# This migration fixes issues with PATH not being properly added to .zshrc and .bashrc

set -e

echo "Running migration: Fix PATH configuration"

# Ensure shell config files exist
touch "$HOME/.zshrc" 2>/dev/null || true
touch "$HOME/.bashrc" 2>/dev/null || true

# Remove old PATH entries (more robust approach)
if [ -f "$HOME/.zshrc" ]; then
    grep -v 'makaron/bin' "$HOME/.zshrc" > "$HOME/.zshrc.tmp" 2>/dev/null && mv "$HOME/.zshrc.tmp" "$HOME/.zshrc" || true
fi

if [ -f "$HOME/.bashrc" ]; then
    grep -v 'makaron/bin' "$HOME/.bashrc" > "$HOME/.bashrc.tmp" 2>/dev/null && mv "$HOME/.bashrc.tmp" "$HOME/.bashrc" || true
fi

# Add new PATH entry
echo 'export PATH="$HOME/.local/share/makaron/bin:$PATH"' >> "$HOME/.zshrc"
echo 'export PATH="$HOME/.local/share/makaron/bin:$PATH"' >> "$HOME/.bashrc"

# Verify PATH was added
if grep -q 'makaron/bin' "$HOME/.zshrc" 2>/dev/null; then
    echo "✓ PATH successfully added to .zshrc"
else
    echo "✗ Warning: Failed to add PATH to .zshrc"
fi

echo "Migration completed - PATH has been fixed"
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc' for changes to take effect"


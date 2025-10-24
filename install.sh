#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Makaron locations
export MAKARON_PATH="$HOME/.local/share/makaron"
export MAKARON_INSTALL="$MAKARON_PATH/install"
export MAKARON_INSTALL_LOG_FILE="$MAKARON_PATH/log/makaron-install.log"
export PATH="$MAKARON_PATH/bin:$PATH"

# Repository URL
REPO_URL="https://github.com/grzegorzbartman/makaron.git"

# Clone or update repository
if [ -d "$MAKARON_PATH/.git" ]; then
    echo "Updating existing installation..."
    cd "$MAKARON_PATH"
    git pull origin main
else
    echo "Cloning repository to $MAKARON_PATH..."
    # Remove directory if it exists but is not a git repo
    if [ -d "$MAKARON_PATH" ]; then
        rm -rf "$MAKARON_PATH"
    fi
    git clone "$REPO_URL" "$MAKARON_PATH"
fi

# Create log directory after cloning
mkdir -p "$(dirname "$MAKARON_INSTALL_LOG_FILE")"

# Change to the cloned directory
cd "$MAKARON_PATH"

# Run all installations
echo "Starting installation process..."
bash "$MAKARON_PATH/install/all.sh"

# Add bin directory to PATH
echo "Setting up PATH..."
# Remove old PATH entries first
sed -i '' '/makaron\/bin/d' "$HOME/.zshrc" 2>/dev/null || true
sed -i '' '/makaron\/bin/d' "$HOME/.bashrc" 2>/dev/null || true

# Add new PATH entry
echo 'export PATH="$HOME/.local/share/makaron/bin:$PATH"' >> "$HOME/.zshrc"
echo 'export PATH="$HOME/.local/share/makaron/bin:$PATH"' >> "$HOME/.bashrc"

# Add to current session
export PATH="$HOME/.local/share/makaron/bin:$PATH"

# Set execute permissions on bin files
echo "Setting execute permissions on bin files..."
chmod +x "$MAKARON_PATH/bin"/* 2>/dev/null || true

echo "Added $MAKARON_PATH/bin to PATH in shell config files"

echo "Installation completed successfully!"
echo ""
echo "Available commands:"
echo "  makaron-update                      - Update the configuration"
echo "  makaron-reload-aerospace-sketchybar - Reload all configurations"
echo ""
echo "Note: You may need to restart your terminal or run 'source ~/.zshrc' to use the new commands."

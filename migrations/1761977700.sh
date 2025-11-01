#!/bin/bash

# Migration: Move DDEV from tools/ to development/ directory
# Installs development tools (VS Code, Cursor, PHPStorm) for existing users
# DDEV is now part of the development tools suite along with VS Code, Cursor, and PHPStorm

set -e

error_exit() {
  echo -e "\033[31mERROR: Migration failed! Manual intervention required.\033[0m" >&2
  exit 1
}

trap error_exit ERR

echo "Running migration: Setup development tools directory and install applications"

# Set MAKARON_PATH if not already set
MAKARON_PATH="${MAKARON_PATH:-$HOME/.local/share/makaron}"

# Ensure development directory exists (in case files aren't there yet after git pull)
mkdir -p "$MAKARON_PATH/install/development"

# Install development tools if script files exist and applications are not installed
if [ -f "$MAKARON_PATH/install/development/vscode.sh" ]; then
    echo "Installing Visual Studio Code..."
    source "$MAKARON_PATH/install/development/vscode.sh"
else
    echo "VS Code installation script not found, skipping"
fi

if [ -f "$MAKARON_PATH/install/development/cursor.sh" ]; then
    echo "Installing Cursor..."
    source "$MAKARON_PATH/install/development/cursor.sh"
else
    echo "Cursor installation script not found, skipping"
fi

if [ -f "$MAKARON_PATH/install/development/phpstorm.sh" ]; then
    echo "Installing PHPStorm..."
    source "$MAKARON_PATH/install/development/phpstorm.sh"
else
    echo "PHPStorm installation script not found, skipping"
fi

# DDEV migration is already handled by git pull - the file was moved in the repository
# Individual installation scripts check if applications are already installed (idempotent)
echo "Migration completed successfully"


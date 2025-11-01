#!/bin/bash

# Migration: Install new applications (Alt Tab, Stats, Slack, Docker Desktop, Sequel Ace)
# Adds installation scripts for new tools and development applications for existing users

set -e

error_exit() {
  echo -e "\033[31mERROR: Migration failed! Manual intervention required.\033[0m" >&2
  exit 1
}

trap error_exit ERR

echo "Running migration: Install new applications"

# Set MAKARON_PATH if not already set
MAKARON_PATH="${MAKARON_PATH:-$HOME/.local/share/makaron}"

# Install tools applications
if [ -f "$MAKARON_PATH/install/tools/alt-tab.sh" ]; then
    echo "Installing Alt Tab..."
    source "$MAKARON_PATH/install/tools/alt-tab.sh"
else
    echo "Alt Tab installation script not found, skipping"
fi

if [ -f "$MAKARON_PATH/install/tools/stats.sh" ]; then
    echo "Installing Stats..."
    source "$MAKARON_PATH/install/tools/stats.sh"
else
    echo "Stats installation script not found, skipping"
fi

if [ -f "$MAKARON_PATH/install/tools/slack.sh" ]; then
    echo "Installing Slack..."
    source "$MAKARON_PATH/install/tools/slack.sh"
else
    echo "Slack installation script not found, skipping"
fi

# Install development applications
if [ -f "$MAKARON_PATH/install/development/docker-desktop.sh" ]; then
    echo "Installing Docker Desktop..."
    source "$MAKARON_PATH/install/development/docker-desktop.sh"
else
    echo "Docker Desktop installation script not found, skipping"
fi

if [ -f "$MAKARON_PATH/install/development/sequel-ace.sh" ]; then
    echo "Installing Sequel Ace..."
    source "$MAKARON_PATH/install/development/sequel-ace.sh"
else
    echo "Sequel Ace installation script not found, skipping"
fi

# Individual installation scripts check if applications are already installed (idempotent)
echo "Migration completed successfully"


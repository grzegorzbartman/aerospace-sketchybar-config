#!/bin/bash

# Install Docker Desktop for macOS ARM
DOCKER_APP="/Applications/Docker.app"
DOCKER_DMG_URL="https://desktop.docker.com/mac/main/arm64/Docker.dmg"
TMP_DIR="/tmp/makaron-install"
DMG_FILE="$TMP_DIR/Docker.dmg"
MOUNT_POINT="/Volumes/Docker"

# Check if Docker Desktop is already installed
if [ -d "$DOCKER_APP" ]; then
    echo "Docker Desktop is already installed"
    exit 0
fi

# Cleanup function
cleanup() {
    if [ -d "$MOUNT_POINT" ]; then
        hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
    fi
    rm -f "$DMG_FILE"
    rmdir "$TMP_DIR" 2>/dev/null || true
}

trap cleanup EXIT

# Create temporary directory
mkdir -p "$TMP_DIR"

# Download Docker Desktop DMG
echo "Downloading Docker Desktop..."
if ! curl -L "$DOCKER_DMG_URL" -o "$DMG_FILE"; then
    echo "Error: Failed to download Docker Desktop"
    exit 1
fi

# Mount the DMG
echo "Mounting Docker Desktop DMG..."
if ! hdiutil attach "$DMG_FILE" -quiet; then
    echo "Error: Failed to mount Docker Desktop DMG"
    exit 1
fi

# Wait a moment for mount to be ready
sleep 1

# Copy Docker.app to Applications
echo "Installing Docker Desktop..."
if [ ! -d "$MOUNT_POINT/Docker.app" ]; then
    echo "Error: Docker.app not found in DMG"
    exit 1
fi

cp -R "$MOUNT_POINT/Docker.app" /Applications/

# Unmount the DMG
echo "Unmounting DMG..."
hdiutil detach "$MOUNT_POINT" -quiet

echo "Docker Desktop installed successfully"
echo "Note: You may need to open Docker Desktop manually to complete the setup"


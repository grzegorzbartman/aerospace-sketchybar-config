#!/bin/bash

# Install Sequel Ace
if ! brew list --cask sequel-ace &> /dev/null; then
    echo "Installing Sequel Ace..."
    brew install --cask sequel-ace
fi


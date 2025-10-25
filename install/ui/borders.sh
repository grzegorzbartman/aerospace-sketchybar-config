#!/bin/bash

# Install borders
if ! command -v borders &> /dev/null; then
    brew tap FelixKratz/formulae
    brew install borders
fi

# Start borders service if not running
if ! brew services list | grep -q "borders.*started"; then
    brew services start borders
fi

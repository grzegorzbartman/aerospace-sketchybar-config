#!/bin/bash

# Install DDEV
if ! command -v ddev &> /dev/null; then
    brew install ddev/ddev/ddev
fi


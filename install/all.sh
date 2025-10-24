#!/bin/bash

# Source all installation scripts
source "$MAKARON_PATH/install/brew.sh"
source "$MAKARON_PATH/install/ui/all.sh"
source "$MAKARON_PATH/install/tools/all.sh"
source "$MAKARON_PATH/install/macos_settings.sh"
source "$MAKARON_PATH/install/migrations.sh"

# Reload all configurations
bash "$MAKARON_PATH/bin/makaron-reload-aerospace-sketchybar"

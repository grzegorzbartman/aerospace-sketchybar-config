#!/bin/bash

# Initialize migration system
# Creates state directory and marks existing migrations as completed

MAKARON_MIGRATIONS_STATE_PATH="$HOME/.local/state/makaron/migrations"
mkdir -p "$MAKARON_MIGRATIONS_STATE_PATH"

# Mark all existing migrations as completed (they were already applied during initial setup)
for file in "$MAKARON_PATH/migrations"/*.sh; do
  if [[ -f "$file" ]]; then
    filename=$(basename "$file")
    touch "$MAKARON_MIGRATIONS_STATE_PATH/$filename"
    echo "Marked migration $filename as completed"
  fi
done

echo "Migration system initialized"

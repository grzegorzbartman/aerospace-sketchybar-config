#!/bin/sh
# macOS memory percent for SketchyBar: (App Memory + Wired + Compressed) / Total

# Load theme colors
MAKARON_PATH="${MAKARON_PATH:-$HOME/.local/share/makaron}"
THEME_DIR="$MAKARON_PATH/current-theme"
if [ -f "$THEME_DIR/sketchybar.colors" ]; then
  source "$THEME_DIR/sketchybar.colors"
fi

# Get page size and total RAM in one sysctl call
eval "$(sysctl -n vm.pagesize hw.memsize | awk 'NR==1{print "PAGE_SIZE="$1} NR==2{print "TOTAL_BYTES="$1}')"

# Parse vm_stat output efficiently in one pass
eval "$(vm_stat | awk '
/^Pages active:/ { print "ACTIVE=" $3 }
/^Pages speculative:/ { print "SPECULATIVE=" $3 }
/^Pages wired down:/ { print "WIRED=" $4 }
/^Pages occupied by compressor:/ { print "COMPRESSED=" $5 }
' | tr -d '.')"

# Calculate used memory (App Memory + Wired + Compressed)
USED_PAGES=$((ACTIVE + SPECULATIVE + WIRED + COMPRESSED))
USED_BYTES=$((USED_PAGES * PAGE_SIZE))

# Convert to GB (divide by 1024^3)
USED_GB=$((USED_BYTES / 1073741824))
TOTAL_GB=$((TOTAL_BYTES / 1073741824))

# Error handling for invalid values
if [ -z "$USED_GB" ] || [ -z "$TOTAL_GB" ] || ! [[ "$USED_GB" =~ ^[0-9]+$ ]] || ! [[ "$TOTAL_GB" =~ ^[0-9]+$ ]]; then
  MEMORY_DISPLAY="N/A"
else
  MEMORY_DISPLAY="${USED_GB}/${TOTAL_GB} GB"
fi

# Update SketchyBar with error handling
sketchybar --set "$NAME" label="$MEMORY_DISPLAY" \
  label.color="${LABEL_COLOR:-0xffc0caf5}" 2>/dev/null || {
  echo "Error updating memory display" >&2
  exit 1
}

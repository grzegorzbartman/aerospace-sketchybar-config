#!/bin/sh
# CPU usage percentage for SketchyBar

# Get CPU usage from top (idle percentage)
CPU_IDLE=$(top -l 1 | grep "CPU usage" | awk '{print $7}' | sed 's/%//')

# Calculate CPU usage (100 - idle)
if [ -n "$CPU_IDLE" ] && [[ "$CPU_IDLE" =~ ^[0-9]+\.?[0-9]*$ ]]; then
  CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
  # Round to 1 decimal place
  CPU_USAGE=$(printf "%.1f" "$CPU_USAGE")
  CPU_DISPLAY="${CPU_USAGE}%"
else
  CPU_DISPLAY="N/A"
fi

# Update SketchyBar with error handling
sketchybar --set "$NAME" label="$CPU_DISPLAY" 2>/dev/null || {
  echo "Error updating CPU display" >&2
  exit 1
}

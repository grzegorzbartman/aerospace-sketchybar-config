#!/usr/bin/env bash

# This script highlights the focused AeroSpace workspace and shows app icons

WORKSPACE=$1

# Map app names to icons (using Nerd Font icons)
get_app_icon() {
case "$1" in
"kitty"|"Alacritty"|"iTerm2"|"Terminal"|"WezTerm"|"Ghostty") echo "" ;;
"Safari"|"safari") echo "󰀹" ;;
"Google Chrome"|"Chrome"|"Chromium") echo "" ;;
"Firefox"|"Firefox Developer Edition") echo "" ;;
"Arc") echo "" ;;
"Brave Browser") echo "󰖟" ;;
"Code"|"Visual Studio Code"|"VSCodium") echo "󰨞" ;;
"Cursor") echo "󰨞" ;;
"Finder") echo "" ;;
"Mail"|"Mimestream") echo "" ;;
"Calendar"|"Fantastical") echo "" ;;
"Messages") echo "󰍦" ;;
"Slack") echo "" ;;
"Discord") echo "󰙯" ;;
"Telegram") echo "" ;;
"WhatsApp") echo "" ;;
"Spotify"|"Music") echo "" ;;
"Notes") echo "" ;;
"Todoist") echo "" ;;
"Obsidian") echo "󱓷" ;;
"Notion") echo "󰈚" ;;
"Preview") echo "󰋩" ;;
"Photoshop") echo "" ;;
"Illustrator") echo "" ;;
"Figma") echo "" ;;
"IntelliJ IDEA"|"IntelliJ IDEA CE") echo "" ;;
"PHPStorm") echo "" ;;
"PyCharm"|"PyCharm CE") echo "" ;;
"WebStorm") echo "" ;;
"Android Studio") echo "" ;;
"Xcode") echo "" ;;
"Docker"|"Docker Desktop") echo "" ;;
"Postman") echo "󰘯" ;;
"TablePlus"|"Sequel Pro"|"DBeaver") echo "" ;;
"VLC") echo "󰕼" ;;
"IINA") echo "󰕼" ;;
"Zoom"|"zoom.us") echo "󰍩" ;;
"Microsoft Teams") echo "󰊻" ;;
"System Settings"|"System Preferences") echo "" ;;
"App Store") echo "" ;;
"TV") echo "" ;;
"Activity Monitor") echo "" ;;
*) echo "" ;; # Default icon for unknown apps
esac
}

# Get list of apps in this workspace
apps=""
if [[ $(aerospace list-workspaces --focused) == "$WORKSPACE" ]]; then
# Focused workspace - TokyoNight active colors
sketchybar --set "$NAME" \
  background.drawing=on \
  background.color=0xff1a1b26 \
  background.border_color=0xff7aa2f7 \
  background.border_width=2 \
  icon.color=0xffc0caf5 \
  label.color=0xffc0caf5
else
# Inactive workspace - TokyoNight inactive colors
sketchybar --set "$NAME" \
  background.drawing=on \
  background.color=0xff24283b \
  background.border_color=0xff3b4261 \
  background.border_width=1 \
  icon.color=0xffa9b1d6 \
  label.color=0xffa9b1d6
fi

# Get windows in this workspace and extract unique app names
windows=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | awk -F'|' '{print $2}' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u)

# Build icon string
icons=""
while IFS= read -r app; do
if [[ -n "$app" ]]; then
icon=$(get_app_icon "$app")
if [[ -n "$icons" ]]; then
icons="$icons $icon" # Add space between icons
else
icons="$icon"
fi
fi
done <<< "$windows"

    # Update the label with app icons
    if [[ -n "$icons" ]]; then
    sketchybar --set "$NAME" label="$icons" label.drawing=on
    else
    sketchybar --set "$NAME" label="" label.drawing=off
    fi

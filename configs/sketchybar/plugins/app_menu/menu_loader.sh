#!/usr/bin/env bash

# App Menu loader with lazy-loaded submenu support

CMD="${1:-toggle}"
MENU_PATH="${2:-}"

PLUGIN_DIR="${PLUGIN_DIR:-${CONFIG_DIR:-$HOME/.config/sketchybar}/plugins}"
MAKARON_PATH="${MAKARON_PATH:-$HOME/.local/share/makaron}"
THEME_DIR="$MAKARON_PATH/current-theme"

if ! command -v jq &>/dev/null; then
    echo "Error: jq is required for app menu. Install with: brew install jq" >&2
    exit 1
fi

check_accessibility() {
    if ! osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' &>/dev/null; then
        osascript -e 'display notification "App Menu requires Accessibility permissions for SketchyBar and osascript.\n\nGo to: System Settings → Privacy & Security → Accessibility" with title "SketchyBar App Menu" sound name "Basso"' 2>/dev/null
        return 1
    fi
    return 0
}

[ -f "$THEME_DIR/sketchybar.colors" ] && source "$THEME_DIR/sketchybar.colors"

POPUP_BG_COLOR="${BAR_BACKGROUND_COLOR:-0xff1a1b26}"
POPUP_BORDER_COLOR="${SPACE_BORDER_COLOR:-0xff3b4261}"
MENU_ITEM_COLOR="${LABEL_COLOR:-0xffc0caf5}"
MENU_DISABLED_COLOR="0xff6b7089"
SEPARATOR_COLOR="0xff3b4261"

clear_menu() {
    sketchybar --query app_menu 2>/dev/null | jq -r '.popup.items[]?' | while read -r item; do
        [ -n "$item" ] && sketchybar --remove "$item" 2>/dev/null
    done
}

case "$CMD" in
    toggle)
        STATE=$(sketchybar --query app_menu 2>/dev/null | jq -r '.popup.drawing')

        if [ "$STATE" = "on" ]; then
            sketchybar --set app_menu popup.drawing=off
            clear_menu
        else
            sketchybar --set app_menu popup.drawing=on
            "$0" load_top
        fi
        ;;

    load_top)
        clear_menu

        if ! check_accessibility; then
            exit 0
        fi

        MENUS=$(osascript 2>/dev/null << 'EOF'
on run
    set frontApp to do shell script "osascript -e 'tell application \"System Events\" to name of first application process whose frontmost is true'"

    tell application "System Events"
        tell process frontApp
            set menuList to {}
            set idx to 0
            repeat with mb in menu bar items of menu bar 1
            try
                set menuName to name of mb
                if menuName is not "Apple" then
                    set hasSubmenu to false
                    try
                        set m to menu 1 of mb
                        set hasSubmenu to true
                    end try
                    if hasSubmenu then
                        set end of menuList to menuName & "|" & idx & "|Y"
                    else
                        set end of menuList to menuName & "|" & idx & "|N"
                    end if
                end if
            end try
                set idx to idx + 1
            end repeat
            return menuList
        end tell
    end tell
end run
EOF
)

        i=0
        echo "$MENUS" | tr ',' '\n' | while read -r line; do
            IFS='|' read -r name idx has_sub <<< "$(echo "$line" | tr -d ' "')"

            if [ -n "$name" ] && [ "$name" != "missing" ]; then
                if [ "$has_sub" = "Y" ]; then
                    sketchybar --add item "app_menu.item.$i" popup.app_menu \
                        --set "app_menu.item.$i" \
                            label="$name ▸" \
                            label.color="$MENU_ITEM_COLOR" \
                            icon.drawing=off \
                            background.color="$POPUP_BG_COLOR" \
                            background.corner_radius=6 \
                            click_script="$PLUGIN_DIR/app_menu/menu_loader.sh load_sub '$idx'"
                else
                    sketchybar --add item "app_menu.item.$i" popup.app_menu \
                        --set "app_menu.item.$i" \
                            label="$name" \
                            label.color="$MENU_ITEM_COLOR" \
                            icon.drawing=off \
                            background.color="$POPUP_BG_COLOR" \
                            background.corner_radius=6
                fi
                i=$((i + 1))
                [ $i -gt 30 ] && break
            fi
        done
        ;;

    load_sub)
        [ -z "$MENU_PATH" ] && exit 0

        clear_menu

        sketchybar --add item "app_menu.item.back" popup.app_menu \
            --set "app_menu.item.back" \
                label="‹ Back" \
                label.color="$MENU_ITEM_COLOR" \
                icon.drawing=off \
                background.color="$POPUP_BG_COLOR" \
                background.corner_radius=6 \
                click_script="$PLUGIN_DIR/app_menu/menu_loader.sh load_top"

        sketchybar --add item "app_menu.item.sep" popup.app_menu \
            --set "app_menu.item.sep" \
                label="────────" \
                label.color="$SEPARATOR_COLOR" \
                icon.drawing=off \
                background.drawing=off

        MENU_INDEX=$((MENU_PATH + 1))

        ITEMS=$(MENU_INDEX=$MENU_INDEX osascript 2>/dev/null << 'EOF'
on run
    set frontApp to do shell script "osascript -e 'tell application \"System Events\" to name of first application process whose frontmost is true'"
    set menuIdx to (do shell script "echo $MENU_INDEX") as integer

    tell application "System Events"
        tell process frontApp
            try
                set menuBarItem to menu bar item menuIdx of menu bar 1
                set menuItems to menu items of menu 1 of menuBarItem
                set itemList to {}
                set itemIdx to 0
                repeat with mi in menuItems
                    try
                        set itemName to name of mi
                        set itemEnabled to enabled of mi
                        set hasSubmenu to false
                        try
                            set sm to menu 1 of mi
                            set hasSubmenu to true
                        end try
                        if itemName is missing value then
                            set end of itemList to "---|" & itemIdx
                        else if hasSubmenu then
                            set end of itemList to itemName & "|" & itemIdx & "|SUB|" & itemEnabled
                        else if itemEnabled then
                            set end of itemList to itemName & "|" & itemIdx & "|ACT|true"
                        else
                            set end of itemList to itemName & "|" & itemIdx & "|ACT|false"
                        end if
                    end try
                    set itemIdx to itemIdx + 1
                end repeat
                return itemList
            on error
                return {}
            end try
        end tell
    end tell
end run
EOF
)

        APP=$(osascript -e 'tell application "System Events" to name of first application process whose frontmost is true' 2>/dev/null)

        i=2
        echo "$ITEMS" | tr ',' '\n' | while read -r item; do
            item=$(echo "$item" | xargs)
            IFS='|' read -r name idx type enabled <<< "$item"

            name=$(echo "$name" | tr -d '"')

            if [ "$name" = "---" ]; then
                sketchybar --add item "app_menu.sub.$i" popup.app_menu \
                    --set "app_menu.sub.$i" \
                        label="────────" \
                        label.color="$SEPARATOR_COLOR" \
                        icon.drawing=off \
                        background.drawing=off
            elif [ -n "$name" ]; then
                if [ "$type" = "SUB" ]; then
                    sketchybar --add item "app_menu.sub.$i" popup.app_menu \
                        --set "app_menu.sub.$i" \
                            label="$name" \
                            label.color="$MENU_DISABLED_COLOR" \
                            icon.drawing=off \
                            background.color="$POPUP_BG_COLOR" \
                            background.corner_radius=6
                elif [ "$enabled" = "false" ]; then
                    sketchybar --add item "app_menu.sub.$i" popup.app_menu \
                        --set "app_menu.sub.$i" \
                            label="$name" \
                            label.color="$MENU_DISABLED_COLOR" \
                            icon.drawing=off \
                            background.color="$POPUP_BG_COLOR" \
                            background.corner_radius=6
                else
                    sketchybar --add item "app_menu.sub.$i" popup.app_menu \
                        --set "app_menu.sub.$i" \
                            label="$name" \
                            label.color="$MENU_ITEM_COLOR" \
                            icon.drawing=off \
                            background.color="$POPUP_BG_COLOR" \
                            background.corner_radius=6 \
                            click_script="$PLUGIN_DIR/app_menu/click_menu.applescript \"$APP\" \"$MENU_PATH/$idx\" && sketchybar --set app_menu popup.drawing=off"
                fi
            fi
            i=$((i + 1))
            [ $i -gt 50 ] && break
        done
        ;;
esac

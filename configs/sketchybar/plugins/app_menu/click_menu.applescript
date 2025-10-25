#!/usr/bin/env osascript

on run argv
    if (count of argv) < 2 then
        return "Usage: click_menu.applescript <app_name> <path>"
    end if

    set appName to item 1 of argv
    set pathString to item 2 of argv

    return clickMenuPath(appName, pathString)
end run

on clickMenuPath(appName, pathString)
    set AppleScript's text item delimiters to "/"
    set pathParts to text items of pathString

    if (count of pathParts) < 1 then
        return "Error: Invalid path"
    end if

    set quotedAppName to quoted form of appName

    tell application "System Events"
        tell process appName
            try
                set menuBarIndex to (item 1 of pathParts as integer) + 1
                set currentMenuItem to menu bar item menuBarIndex of menu bar 1

                click currentMenuItem
                delay 0.1

                if (count of pathParts) > 1 then
                    set currentMenu to menu 1 of currentMenuItem

                    repeat with i from 2 to (count of pathParts)
                        set itemIndex to (item i of pathParts as integer) + 1
                        set currentMenuItem to menu item itemIndex of currentMenu

                        if i < (count of pathParts) then
                            try
                                delay 0.1
                                set currentMenu to menu 1 of currentMenuItem
                            on error
                                click currentMenuItem
                                return "Clicked: " & (name of currentMenuItem)
                            end try
                        else
                            click currentMenuItem
                            try
                                return "Clicked: " & (name of currentMenuItem)
                            on error
                                return "Clicked item at path: " & pathString
                            end try
                        end if
                    end repeat
                end if

                return "Success"
            on error errMsg
                return "Error: " & errMsg
            end try
        end tell
    end tell
end clickMenuPath

# AeroSpace-config

Configuration file for AeroSpace that solves the problem of keyboard shortcuts conflicting with Polish characters.

[AeroSpace project page](https://github.com/nikitabobko/AeroSpace)

## Additional Settings

### Mission Control Fix

Mission Control may display windows too small when AeroSpace places many windows in the bottom right corner. To fix this, enable "Group windows by application":

```bash
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

Or via System Settings: **Desktop & Dock → Group windows by application**




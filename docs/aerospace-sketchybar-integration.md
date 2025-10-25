# AeroSpace + SketchyBar Integration

## Overview

This document explains how AeroSpace window manager integrates with SketchyBar to display workspace indicators with proper highlighting and app icons.

## How It Works

### 1. AeroSpace Configuration

In `configs/aerospace/.aerospace.toml`:

```toml
exec-on-workspace-change = ['/bin/bash', '-c',
    'sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE'
]
```

**Critical:** This callback is REQUIRED. Without it:
- Empty workspaces won't highlight correctly
- The system falls back to querying `aerospace list-workspaces --focused` which doesn't work reliably with empty workspaces

### 2. SketchyBar Configuration

In `configs/sketchybar/sketchybarrc`:

```bash
# Add custom event
sketchybar --add event aerospace_workspace_change

# For each workspace
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change front_app_switched \
    --set space.$sid \
    script="$PLUGIN_DIR/aerospace.sh $sid"
done
```

**Important:** Each workspace subscribes to TWO events:
- `aerospace_workspace_change` - when switching workspaces
- `front_app_switched` - when apps change (to update icons)

### 3. Plugin Script Logic

In `configs/sketchybar/plugins/aerospace.sh`:

```bash
# Get focused workspace from environment variable (set by aerospace exec-on-workspace-change)
# If not set (e.g., from front_app_switched event), query aerospace
if [[ -z "$FOCUSED_WORKSPACE" ]]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

if [[ "$FOCUSED_WORKSPACE" == "$WORKSPACE" ]]; then
  # Focused workspace - highlighted
else
  # Inactive workspace
fi
```

**Critical Logic:**
1. **Primary:** Use `$FOCUSED_WORKSPACE` environment variable (from aerospace callback)
2. **Fallback:** If empty, query aerospace (for `front_app_switched` events)
3. This hybrid approach handles both scenarios correctly

## Why This Approach?

### Problem with Querying Aerospace Directly

`aerospace list-workspaces --focused` has a bug/limitation:
- Works fine for workspaces with applications
- **Fails for empty workspaces** - returns the last non-empty focused workspace instead

Example:
```bash
# User is on workspace 8 (empty)
aerospace list-workspaces --focused
# Returns: 3  <- WRONG! This is the last non-empty workspace
```

### Solution: Event-Driven Approach

Using `exec-on-workspace-change`:
- AeroSpace sends `$AEROSPACE_FOCUSED_WORKSPACE` when workspace changes
- Works correctly for ALL workspaces (empty or not)
- Plugin receives reliable data directly

### Why Keep the Fallback?

The `front_app_switched` event doesn't include `$FOCUSED_WORKSPACE`:
- Triggers when apps open/close/switch within current workspace
- Need to update app icons without workspace change
- Must query aerospace in this case (but workspace has apps, so query works)

## Common Mistakes to Avoid

### ❌ DON'T: Remove exec-on-workspace-change

```toml
# BAD - commenting this out breaks empty workspace highlighting
# exec-on-workspace-change = [...]
```

### ❌ DON'T: Only query aerospace

```bash
# BAD - this breaks empty workspaces
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
```

### ❌ DON'T: Only use environment variable

```bash
# BAD - this breaks front_app_switched events
if [[ "$FOCUSED_WORKSPACE" == "$WORKSPACE" ]]; then
```

### ✅ DO: Use hybrid approach

```bash
# GOOD - works for all scenarios
if [[ -z "$FOCUSED_WORKSPACE" ]]; then
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi
```

## Testing

### Test Empty Workspaces
1. Switch to an empty workspace (e.g., workspace 8)
2. Verify it's highlighted with border
3. Icons should not appear

### Test Workspaces with Apps
1. Switch to workspace with applications (e.g., workspace 3)
2. Verify it's highlighted with border
3. Icons should appear for running apps
4. Open a new app - icons should update
5. Close an app - icons should update

### Test Switching Between Workspaces
1. Switch from workspace 3 (with apps) to workspace 8 (empty)
2. Workspace 3 should lose highlight
3. Workspace 8 should gain highlight
4. Repeat in reverse

## Event Flow

### Scenario 1: Switch to Empty Workspace

```
User: alt-8
  ↓
AeroSpace: exec-on-workspace-change
  ↓
SketchyBar: aerospace_workspace_change FOCUSED_WORKSPACE=8
  ↓
aerospace.sh: $FOCUSED_WORKSPACE is set to 8
  ↓
All workspaces: Check if $WORKSPACE == 8
  ↓
Workspace 8: Highlight (match!)
Other workspaces: Unhighlight
```

### Scenario 2: App Switches on Current Workspace

```
User: Opens new app on workspace 3
  ↓
SketchyBar: front_app_switched event
  ↓
aerospace.sh: $FOCUSED_WORKSPACE is empty
  ↓
aerospace.sh: Query aerospace list-workspaces --focused
  ↓
Returns: 3 (works because workspace has apps)
  ↓
Workspace 3: Update icons, keep highlight
```

## Troubleshooting

### Empty workspaces not highlighting

**Check:** Is `exec-on-workspace-change` configured in aerospace.toml?

```bash
grep -A2 "exec-on-workspace-change" ~/.aerospace.toml
```

**Fix:** Add the callback configuration and reload:
```bash
aerospace reload-config
```

### Workspaces with apps losing highlight

**Check:** Does aerospace.sh have the fallback query?

```bash
grep -A3 "if \[\[ -z" ~/.config/sketchybar/plugins/aerospace.sh
```

**Fix:** Add fallback logic to query aerospace when `$FOCUSED_WORKSPACE` is empty.

### Icons not updating

**Check:** Is workspace subscribed to `front_app_switched`?

```bash
grep "front_app_switched" ~/.config/sketchybar/sketchybarrc
```

## Architecture Summary

```
┌─────────────────────────────────────────────────────────────────┐
│ AeroSpace Window Manager                                        │
│                                                                 │
│ exec-on-workspace-change callback                               │
│   → Sends FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ SketchyBar                                                      │
│                                                                 │
│ Events:                                                         │
│  • aerospace_workspace_change (with FOCUSED_WORKSPACE var)      │
│  • front_app_switched (no FOCUSED_WORKSPACE var)                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│ aerospace.sh Plugin                                             │
│                                                                 │
│ Logic:                                                          │
│  1. Check if $FOCUSED_WORKSPACE is set                          │
│  2. If empty → query aerospace list-workspaces --focused        │
│  3. Compare with $WORKSPACE to determine highlight              │
│  4. Query apps and display icons                                │
└─────────────────────────────────────────────────────────────────┘
```

## Related Files

- `configs/aerospace/.aerospace.toml` - AeroSpace configuration with callback
- `configs/sketchybar/sketchybarrc` - SketchyBar configuration with events
- `configs/sketchybar/plugins/aerospace.sh` - Plugin script with hybrid logic

## References

- [AeroSpace Documentation](https://nikitabobko.github.io/AeroSpace/)
- [SketchyBar Documentation](https://felixkratz.github.io/SketchyBar/)
- [AeroSpace-SketchyBar Integration Guide](https://nikitabobko.github.io/AeroSpace/goodness#show-aerospace-workspaces-in-sketchybar)


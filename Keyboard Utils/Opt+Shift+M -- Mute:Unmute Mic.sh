#!/bin/bash

# File to store previous volume
STATE_FILE="$HOME/.mic_prev_volume"

# Get current input volume (0-100)
current_vol=$(osascript -e 'input volume of (get volume settings)')

if [ "$current_vol" -gt 0 ]; then
    # --- MUTE ACTION ---
    # Save current volume to state file
    echo "$current_vol" > "$STATE_FILE"

    # Set volume to 0
    osascript -e 'set volume input volume 0'

    # Notification
    osascript -e 'display notification "Chill..." with title "?? Microphone Muted"'

else
    # --- UNMUTE ACTION ---
    # Default to 75 if no state file exists
    restore_vol=75
    restored_from_state=false

    # Read from state file if it exists
    if [ -f "$STATE_FILE" ]; then
        restore_vol=$(cat "$STATE_FILE")
        restored_from_state=true
  fi

    # Restore volume
    osascript -e "set volume input volume $restore_vol"

    # Notification
    if $restored_from_state; then
        osascript -e "display notification \"Start moving that mouth. Mic restored to level: $restore_vol\" with title \"??? Microphone Unmuted\""
  else
        osascript -e "display notification \"Start moving that mouth. ?? Mic restored to default level: $restore_vol\" with title \"??? Microphone Unmuted\""
  fi
fi

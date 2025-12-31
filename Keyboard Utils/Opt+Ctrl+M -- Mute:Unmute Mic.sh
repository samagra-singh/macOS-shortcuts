#!/bin/bash

STATE_FILE="$HOME/.mic_prev_volume"
current_vol=$(osascript -e 'input volume of (get volume settings)')

if [ "$current_vol" -gt 0 ]; then
    echo -n "$current_vol" > "$STATE_FILE"
    osascript -e 'set volume input volume 0'
    osascript -e 'display notification "Chill..." with title "🎤 Microphone Muted"'
else
    restore_vol=75
    restored_from_state=false

    if [ -f "$STATE_FILE" ]; then
        file_val=$(cat "$STATE_FILE")
        if [[ "$file_val" =~ ^[0-9]+$ ]]; then
            restore_vol=$file_val
            restored_from_state=true
        fi
    fi

    osascript -e "set volume input volume $restore_vol"

    if $restored_from_state; then
        osascript -e "display notification \"Start moving that mouth. Mic restored to level: $restore_vol\" with title \"🎤 Microphone Unmuted\""
    else
        osascript -e "display notification \"Start moving that mouth. ⚠️ Mic restored to default level: $restore_vol\" with title \"🎤 Microphone Unmuted\""
    fi
fi

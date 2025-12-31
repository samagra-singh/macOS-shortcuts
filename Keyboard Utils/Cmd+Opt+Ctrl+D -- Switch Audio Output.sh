#!/bin/bash

# CONFIGURATION
# --------------------
SWITCHER="/opt/homebrew/bin/SwitchAudioSource"
MAC_SPK="MacBook Pro Speakers"
# MONITOR_1="BenQ EW3290U"  # Uncomment when you get the new monitor
MONITOR_2="BenQ EW2880U"

# LOGIC
# --------------------

# Get current audio source and trim whitespace
CURRENT=$("$SWITCHER" -c -t output | xargs)
UNKNOWN_CURRENT=false

case "$CURRENT" in
    "$MAC_SPK")
        # NEXT_DEVICE="$MONITOR_1"
        NEXT_DEVICE="$MONITOR_2"
        ;;
    # "$MONITOR_1")
        # NEXT_DEVICE="$MONITOR_2"
        # ;;
    "$MONITOR_2")
        NEXT_DEVICE="$MAC_SPK"
        ;;
    *)
        # If current is unknown (e.g. HomePod/AirPods), reset loop to Mac defaults
        NEXT_DEVICE="$MAC_SPK"
        UNKNOWN_CURRENT=true
        ;;
esac

# EXECUTION
# --------------------
# Attempt to switch output
if "$SWITCHER" -s "$NEXT_DEVICE" -t output; then

    # Optional: Also switch system alert sounds (uncomment if desired)
    # "$SWITCHER" -s "$NEXT_DEVICE" -t system

    if $UNKNOWN_CURRENT; then
        osascript -e "display notification \"Audio source reset from $CURRENT. Add it to the script to support toggling.\" with title \"?? Reset to $NEXT_DEVICE\""
    else
        osascript -e "display notification \"Switched from $CURRENT\" with title \"?? Playing to $NEXT_DEVICE\""
    fi
else
    osascript -e "display notification \"Could not switch to $NEXT_DEVICE\" with title \"?? Error\""
fi

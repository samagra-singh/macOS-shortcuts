#!/bin/bash

# CONFIGURATION
# --------------------
# Install SwitchAudioSource from: https://github.com/deweller/switchaudio-osx
# Get path using: which SwitchAudioSource
SWITCHER="/opt/homebrew/bin/SwitchAudioSource"

# To discover available audio output devices, run:
#   SwitchAudioSource -a -t output
# This lists all available output sources. Copy the exact names here.
#
# Audio output devices array (in order of preference/rotation)
# Add or remove devices as needed. The script will cycle through them.
# First device is the default. Will be used if current device is not in the array.
AUDIO_OUTPUTS=(
    "MacBook Pro Speakers"
    # "BenQ EW3290U"  # Uncomment once new monitor is connected
    "BenQ EW2880U"
    # Add more devices here as needed
)

# LOGIC
# --------------------

# Safety check: ensure array is not empty
if [ ${#AUDIO_OUTPUTS[@]} -eq 0 ]; then
    osascript -e "display notification \"No audio output devices configured in AUDIO_OUTPUTS array. Add devices to the array to use this script.\" with title \"🚫 Configuration Error\""
    exit 1
fi

CURRENT=$("$SWITCHER" -c -t output | xargs)

# Find current device index in array
CURRENT_INDEX=-1
for i in "${!AUDIO_OUTPUTS[@]}"; do
    if [ "${AUDIO_OUTPUTS[$i]}" = "$CURRENT" ]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Determine next device
if [ "$CURRENT_INDEX" -ge 0 ]; then
    NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#AUDIO_OUTPUTS[@]}))
    NEXT_DEVICE="${AUDIO_OUTPUTS[$NEXT_INDEX]}"
    UNKNOWN_CURRENT=false
else
    NEXT_DEVICE="${AUDIO_OUTPUTS[0]}"
    UNKNOWN_CURRENT=true
fi

if "$SWITCHER" -s "$NEXT_DEVICE" -t output; then
    # "$SWITCHER" -s "$NEXT_DEVICE" -t system  # Uncomment to also switch system alerts

    if $UNKNOWN_CURRENT; then
        osascript -e "display notification \"Audio source '$CURRENT' not in rotation list. Switched to $NEXT_DEVICE. To add '$CURRENT' to rotation, run: SwitchAudioSource -a -t output and add it to the AUDIO_OUTPUTS array.\" with title \"⚠️ Reset to $NEXT_DEVICE\""
    else
        osascript -e "display notification \"Switched from $CURRENT\" with title \"🎧 Playing to $NEXT_DEVICE\""
    fi
else
    osascript -e "display notification \"Could not switch to $NEXT_DEVICE\" with title \"🚫 Error\""
fi

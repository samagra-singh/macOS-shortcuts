#!/bin/bash

# 1. GET CURRENT FINDER LOCATION
# --------------------
# Ask Finder for the "insertion location" (active folder)
FINDER_PATH=$(osascript -e '
    tell application "Finder"
        if (count of windows) is 0 then
            -- Fallback to Desktop if no windows are open
            return POSIX path of (path to desktop)
        else
            try
                -- insertion location handles Column view logic perfectly
                set targetFolder to (insertion location as alias)
                return POSIX path of targetFolder
            on error
                return POSIX path of (path to desktop)
            end try
        end if
    end tell
')

# 2. PREPARE FILE INFO
# --------------------
TIMESTAMP=$(date +"%Y%d%m-%H%M%S")
FILENAME="Clipboard-${TIMESTAMP}.txt"
FULL_PATH="${FINDER_PATH}${FILENAME}"

# 3. CHECK CLIPBOARD & WRITE
# --------------------
TEXT_CONTENT=$(pbpaste)

if [ -n "$TEXT_CONTENT" ]; then
    # Write text to the resolved path
    echo "$TEXT_CONTENT" > "$FULL_PATH"

    # Optional: Reveal the new file in Finder so you see it immediately
    # osascript -e "tell application \"Finder\" to reveal POSIX file \"$FULL_PATH\""

    osascript -e "display notification \"Saved to $(basename "$FINDER_PATH")\" with title \"? Pasted clipboard as new file\""
else
    osascript -e "display notification \"Clipboard is empty or not text.\" with title \"? No Text to paste\""
fi

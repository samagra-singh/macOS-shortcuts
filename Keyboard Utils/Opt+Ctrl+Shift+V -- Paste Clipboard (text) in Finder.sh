#!/bin/bash

FINDER_PATH=$(osascript -e '
    tell application "Finder"
        if (count of windows) is 0 then
            return POSIX path of (path to desktop)
        else
            try
                set targetFolder to (insertion location as alias)
                return POSIX path of targetFolder
            on error
                return POSIX path of (path to desktop)
            end try
        end if
    end tell
')

TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="Clipboard-${TIMESTAMP}.txt"
FULL_PATH="${FINDER_PATH}${FILENAME}"
TEXT_CONTENT=$(pbpaste)

if [ -n "$TEXT_CONTENT" ]; then
    echo -n "$TEXT_CONTENT" > "$FULL_PATH"
    osascript -e "display notification \"Saved to $(basename "$FINDER_PATH"). ⚠️ Emojis in clipboard content are preserved but may not work.\" with title \"📋 Pasted clipboard as new file\""
else
    osascript -e "display notification \"Clipboard is empty or not text.\" with title \"? No Text to paste\""
fi

#!/bin/bash

filepath=$(osascript -e '
    tell application "Finder"
        if selection is {} then return ""
        set theItem to (item 1 of (get selection))
        return POSIX path of (theItem as alias)
    end tell
')

if [ -z "$filepath" ]; then
    osascript -e 'display notification "Select a file to copy it to clipboard." with title "🔍 No file selected"'
    exit 0
fi

if [ -d "$filepath" ]; then
    osascript -e 'display notification "Cannot copy folder to clipboard. Select a file or use native copy/paste." with title "🚫 Cannot copy folder"'
    exit 0
fi

filename=$(basename "$filepath")

if [ ! -s "$filepath" ]; then
    osascript -e "display notification \"File (\\\"$filename\\\") is empty. Select a non-empty file to copy.\" with title \"🔍 Empty file\""
    exit 0
fi

# Check if file is binary (perl -B returns true for binary files)
if ! perl -e 'exit 1 if -B $ARGV[0]' "$filepath"; then
    osascript -e "display notification \"File (\\\"$filename\\\") appears to be binary. Select a text file or use native copy/paste.\" with title \"🚫 Cannot copy binary file\""
    exit 0
fi

pbcopy < "$filepath"
osascript -e "display notification \"Copied \\\"$filename\\\" to clipboard. ⚠️ Emojis are preserved but may not paste correctly.\" with title \"📋 Copied to clipboard\""

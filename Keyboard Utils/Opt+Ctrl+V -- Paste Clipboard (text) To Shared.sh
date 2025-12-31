#!/bin/bash

# CONFIGURATION
# --------------------
DEST_DIR="/Users/Shared"
TIMESTAMP=$(date +"%Y%d%m-%H%M%S")
FILENAME="Clipboard-${TIMESTAMP}.txt"

# LOGIC
# --------------------
# pbpaste automatically ignores files and images, returning empty for them.
TEXT_CONTENT=$(pbpaste)

if [ -n "$TEXT_CONTENT" ]; then
    # Content exists -> Save to file
    echo "$TEXT_CONTENT" > "$DEST_DIR/$FILENAME"
    osascript -e "display notification \"Saved as $FILENAME\" with title \"?? Text Pasted to \\\"Shared\\\"\""
else
    # Content is empty -> Must be a File, Image, or Empty
    osascript -e "display notification \"Clipboard contains files, images, or is empty. Only text is supported.\" with title \"?? Unsupported Content\""
fi

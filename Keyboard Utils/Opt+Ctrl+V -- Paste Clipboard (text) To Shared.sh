#!/bin/bash

DEST_DIR="/Users/Shared"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILENAME="Clipboard-${TIMESTAMP}.txt"
TEXT_CONTENT=$(pbpaste)

if [ -n "$TEXT_CONTENT" ]; then
    echo -n "$TEXT_CONTENT" > "$DEST_DIR/$FILENAME"
    osascript -e "display notification \"Saved as $FILENAME. ⚠️ Emojis in clipboard content are preserved but may not work.\" with title \"📋 Text Pasted to \\\"Shared\\\"\""
else
    osascript -e "display notification \"Clipboard contains files, images, or is empty. Only text is supported.\" with title \"🚫 Unsupported Content\""
fi

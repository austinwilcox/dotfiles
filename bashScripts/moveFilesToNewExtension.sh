#!/bin/bash

# Check if both target and new extensions are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <target_extension> <new_extension>"
    exit 1
fi

TARGET_EXTENSION="$1"
NEW_EXTENSION="$2"

# Find all files with the specified extension and change their extension
find . -type f -name "*$TARGET_EXTENSION" -exec sh -c 'mv "$0" "${0%$1}$2"' {} "$TARGET_EXTENSION" "$NEW_EXTENSION" \;

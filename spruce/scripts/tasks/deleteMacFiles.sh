#!/bin/sh
if [ "$1" == "0" ]; then
    echo -n "macOS ._* files will be deleted on save and exit."
    return 0
fi

if [ "$1" == "1" ]; then
    echo -n "Use this to delete any junk files created by macOS."
    return 0
fi

check_and_delete() {
    BASENAME="$(basename "$1")"
    if [ "$BASENAME" = ".DS_Store" ] || \
         [ "$BASENAME" = ".DocumentRevisions-V100" ] || \
         [ "$BASENAME" = ".Spotlight-V100" ] || \
         [ "$BASENAME" = ".TemporaryItems" ] || \
         [ "$BASENAME" = ".Trashes" ] || \
         [ "$BASENAME" = ".fseventsd" ] || \
         [ "$BASENAME" = ".VolumeIcon.icns" ] || \
         [ "$(xxd -p -g2 -c16 "$1" | head -n1)" = "00051607000200004d6163204f532058" ]; then
            rm -rf "$1"
    fi
}

log_message "Cleaning up macOS junk files..."
find "/mnt/SDCARD" \( \
    -name '._*' \
    -or -name '*DS_Store' \
    -or -name '.VolumeIcon.icns' \
    -or -name '.fseventsd' \
    -or -name '.Trashes' \
    -or -name '.TemporaryItems' \
    -or -name '.Spotlight-V100' \
    -or -name '.DocumentRevisions-V100' \) \
    -exec check_and_delete {} +
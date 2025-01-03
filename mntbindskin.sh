#!/bin/sh

## maybe just use this one line in runtime??
## mount --bind /mnt/SDCARD/Themes/SPRUCE-Flip/skin /usr/miyoo/bin/skin


# Define the source and target directories for the bind mount
SOURCE="/mnt/SDCARD/Themes/SPRUCE-Flip/skin"
TARGET="/usr/miyoo/bin/skin"

# Check if the source directory exists
if [ ! -d "$SOURCE" ]; then
    echo "Source directory does not exist: $SOURCE"
    exit 1
fi

# Check if the target directory exists
if [ ! -d "$TARGET" ]; then
    echo "Target directory does not exist: $TARGET"
    exit 1
fi

# Perform the bind mount
mount --bind $SOURCE $TARGET

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "Successfully bind mounted $SOURCE to $TARGET"
else
    echo "Error: Failed to mount $SOURCE to $TARGET"
    exit 1
fi

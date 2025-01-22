#!/bin/sh

# Under macOS read first sector of the $1 (i.e: /dev/disk0) drive and print it on the screen in hex format.
#
# Author: Dawid Bielecki - dawciobiel
# GitHub: https://github.com/dawciobiel
# Version: beta
#
# Usage:
#   ./read-disk-sector-dd-beta-macos.sh <drive-path>

# Check if the first parameter (drive path) is provided
if [ -z "$1" ]; then
    echo "Error: No drive path provided."
    echo "Usage: ./read-disk-sector-dd.sh <drive-path>"
    exit 1
fi

# Check if the provided path exists and is a valid device
if [ ! -e "$1" ]; then
    echo "Error: The specified path '$1' does not exist."
    exit 1
fi

# Check if the specified path is a block device (on macOS, disk devices are typically named /dev/disk*)
if [[ "$1" =~ ^/dev/disk[0-9]+$ ]]; then
    echo "Valid block device found: $1"
else
    echo "Error: The specified path '$1' is not a valid block device."
    exit 1
fi

# Perform the operation
sudo dd if="$1" bs=512 count=1 | hexdump -C

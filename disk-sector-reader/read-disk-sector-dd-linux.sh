#!/bin/sh

# Read first sector of the $1 (i.e: /dev/sda) drive and print it on the screen in hex format.
#
# Author: Dawid Bielecki - dawciobiel
# GitHub: https://github.com/dawciobiel
# Version: 1.0
#
# Usage:
#   ./read-disk-sector-dd-linux.sh /dev/sda
#   ./read-disk-sector-dd-linux.sh /dev/sda > first-sector.bin


# Check if the first parameter (drive path) is provided
if [ -z "$1" ]; then
    echo "Error: No drive path provided."
    echo "Usage: ./read-disk-sector-dd-linux.sh <drive-path>"
    exit 1
fi

# Check if the provided path exists and is a valid device
if [ ! -e "$1" ]; then
    echo "Error: The specified path '$1' does not exist."
    exit 1
fi

# Check if the specified path is a block device (e.g., /dev/sda)
if [ ! -b "$1" ]; then
    echo "Error: The specified path '$1' is not a valid block device."
    exit 1
fi

# Perform the operation
sudo dd if="$1" bs=512 count=1 | hexdump -C

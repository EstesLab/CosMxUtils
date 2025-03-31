#!/bin/bash
# move_mod_rds.sh
#
# This script searches for all Seurat objects ending with _Mod.RDS
# in the specified root directory (recursively) and moves them to a
# destination directory.
#
# Usage:
#    chmod +x move_mod_rds.sh
#   ./move_mod_rds.sh /path/to/root_directory /path/to/destination_directory

# Check if exactly two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/root_directory /path/to/destination_directory"
    exit 1
fi

ROOT_DIR="$1"
DEST_DIR="$2"

# Create destination directory if it does not exist
mkdir -p "$DEST_DIR"

# Find all files ending with _Mod.RDS in ROOT_DIR and move them to DEST_DIR
find "$ROOT_DIR" -type f -name "*_Mod.RDS" -exec mv {} "$DEST_DIR" \;

echo "Moved all _Mod.RDS files from $ROOT_DIR to $DEST_DIR"


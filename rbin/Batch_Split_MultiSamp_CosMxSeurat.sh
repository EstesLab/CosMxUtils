#!/bin/bash
# wrapper.sh
#
# Usage:
#   ./wrapper.sh root_directory [--overwrite]
#
# This script iterates over each subdirectory in the given root_directory.
# For each subdirectory, it checks if a modified RDS file (matching "seuratObject*_Mod.RDS")
# exists. If it exists and the "--overwrite" flag is not provided, it skips that folder.
# Otherwise, it calls the R script (Myscript.R) with the folder as an argument.
#
# NOTE:
#   - Make sure "Myscript.R" is in the same directory as this script (or update the RSCRIPT path).
#   - Ensure the R script is executable (or call it via "Rscript Myscript.R ...").

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 root_directory [--overwrite]"
    exit 1
fi

ROOT_DIR="$1"
OVERWRITE=false
if [ "$2" == "--overwrite" ]; then
    OVERWRITE=true
fi

# Path to the R script (adjust this if needed)
RSCRIPT="./Split_MultiSamp_CosMxSeurat.R"

# Check if the R script exists
if [ ! -f "$RSCRIPT" ]; then
    echo "Error: R script $RSCRIPT not found."
    exit 1
fi

# Loop over subdirectories in ROOT_DIR
for folder in "$ROOT_DIR"/*/; do
    # Remove trailing slash
    folder=${folder%/}
    echo "Processing folder: $folder"

    # Check for a modified RDS file (assuming name starts with "seuratObject" and ends with "_Mod.RDS")
    mod_file=$(find "$folder" -maxdepth 1 -type f -name "seuratObject*_Mod.RDS")
    if [ -n "$mod_file" ] && [ "$OVERWRITE" = false ]; then
        echo "Found modified RDS file: $mod_file. Skipping folder."
        continue
    fi

    # Run the R script with the folder as an argument
    Rscript "$RSCRIPT" "$folder"
    if [ $? -ne 0 ]; then
        echo "Error processing folder: $folder"
    else
        echo "Successfully processed folder: $folder"
    fi
done
#!/bin/bash

# Usage: ./move_stitched_images_and_rds.sh <source_directory> <destination_directory>

SOURCE_DIR="$1"
DEST_DIR="$2"

if [[ -z "$SOURCE_DIR" || -z "$DEST_DIR" ]]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

mkdir -p "$DEST_DIR"

#find all "StitchedImage" directories and move them along with .RDS files
find "$SOURCE_DIR" -type d -name "StitchedImage" | while read -r stitched_dir; do
  relative_path=$(dirname "${stitched_dir#$SOURCE_DIR/}")

  #create the corresponding directory structure in the prime-seq workbook
  mkdir -p "$DEST_DIR/$relative_path"

  # Copy the stitchedImage folder to prime-seq, preserving hierarchy
  cp -r "$stitched_dir" "$DEST_DIR/$relative_path/"

  #find and copy any .RDS files in the same parent directory
  parent_dir=$(dirname "$stitched_dir")
  find "$parent_dir" -maxdepth 1 -type f -name "*.RDS" | while read -r rds_file; do
    cp "$rds_file" "$DEST_DIR/$relative_path/"
  done
done

echo "All 'StitchedImage' folders and associated .RDS files have been moved to $DEST_DIR." 

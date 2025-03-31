# CosMX - Napari - Seurat Pipeline

## Overview

The CosMX - Napari - Seurat Pipeline is designed to process multi-sample CosMX data exported from AtoMX and stitched using Napari. The pipeline then splits a multi-sample Seurat Object into individual per-sample Seurat Objects. The pipeline consists of two main scripts:

1. **Myscript.R** – A headless R script that processes a single folder. It:

   - Searches for an RDS file that starts with "seuratObject" (the unified multi-sample Seurat Object) and loads it.
   - Searches for a CSV file that starts with "NapariLayers" (exported from Napari with per-sample layer data) and loads it.
   - Converts boolean columns in the CSV (all columns except fixed ones such as UID, cell_ID, and any column containing "cell_type") into logical values.
   - Collapses the boolean calls into a new meta feature called `SampleID` (by assigning the column name where the value is TRUE).
   - Adds this metadata to the Seurat object and writes out the modified Seurat Object (with a "_Mod.RDS" suffix) and the modified CSV file.

2. **wrapper.sh** – A Bash wrapper script that batch processes multiple folders under a given root directory. It:

   - Iterates over each subdirectory.
   - Checks if a modified Seurat Object (matching "seuratObject*_Mod.RDS") already exists. If so, and if the `--overwrite` flag is not provided, it skips that folder.
   - Otherwise, it calls `Myscript.R` with the folder as an argument.

## Pre-requisites

Before running the pipeline, ensure you have:

- **Data Exports from AtoMX:**
  - A unified multi-sample Seurat Object exported as an RDS file (filename starts with "seuratObject").
  - A CSV file exported from Napari containing the stitched image layers (filename starts with "NapariLayers").
- **Napari Processing:**
  - Use Napari stitching tools (plus any custom scripts) to generate per-sample layers and export the CSV.
- **Software Requirements:**
  - R and the necessary packages (data.table, magrittr, Seurat, etc.).
  - Bash shell and Rscript.
  - Proper organization: Each folder should contain both the RDS and CSV files as specified.

## rbin/Split_MultiSamp_CosMxSeurat.R

**Usage:**  

```
Rscript Myscript.R path/to/folder
```

This script performs the following steps:

- Loads the Seurat Object from the RDS file.
- Loads the metadata CSV file.
- Dynamically determines fixed columns by including UID, cell_ID, and any column containing "cell_type".
- Converts the remaining (boolean) columns to logical values.
- Collapses these boolean columns into a new meta feature called `SampleID` (assigning the column name where the value is TRUE).
- Adds the metadata to the Seurat object.
- Writes out the modified Seurat Object (with "_Mod.RDS" appended) and a modified CSV file.

## rbin/Batch_Split_MultiSamp_CosMxSeurat.sh

**Usage:**  

```
./wrapper.sh /path/to/root_directory [–overwrite]
```

This script:

- Iterates over each subdirectory in the given root directory.
- For each folder, it checks if a file matching "seuratObject*_Mod.RDS" exists.
- If such a file exists and `--overwrite` is not specified, the folder is skipped.
- Otherwise, it calls `Myscript.R` with that folder.

## Additional Notes

- **Dynamic Fixed Columns:**  
  The script dynamically extracts any column names containing "cell_type" to account for variations (e.g., cell_type_1, cell_type_2, etc.).
- **Reproducibility:**  
  The pipeline is designed to run headlessly, ensuring that processing is reproducible across multiple datasets.
- **Error Handling:**  
  Both scripts include basic error checking (e.g., missing files) and will halt if necessary.
- **Multi-User Considerations for VNC (if applicable):**  
  Users can set up individual VNC sessions or configure a shared VNC session based on their requirements.

## Conclusion

This pipeline streamlines the processing of CosMX data by integrating stitched image layers with multi-sample Seurat Objects, enabling downstream analysis with per-sample metadata. For modifications or troubleshooting, please refer to the inline comments in the scripts.



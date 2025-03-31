# Myscript.R
# Usage: Rscript Myscript.R path/to/my/dir
#
# This script processes a directory containing:
#   - an RDS file whose name starts with "seuratObject" (a Seurat object)
#   - a CSV file whose name starts with "NapariLayers" (cell metadata)
#
# It collapses boolean columns in the CSV into a single meta feature ("SampleID"),
# adds this metadata to the Seurat object, and then writes the modified Seurat object
# and CSV file back to disk.

# -------------------------------
# 1. Get the Directory Path
# -------------------------------
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  warning("No directory path as an argument was passed")
  warning("Usage: Rscript Myscript.R path/to/dir")
  warning("Default path is the current directory './'")
  dir_path <- "./"
} else {
  dir_path <- args[1]
}

# -------------------------------
# 2. Load Required Packages
# -------------------------------
# Install required packages using BiocManager if needed:
# BiocManager::install(c("data.table", "magrittr", "Seurat"))
suppressMessages(library(data.table))
suppressMessages(library(magrittr))
suppressMessages(library(Seurat))

# -------------------------------
# 3. Load the Seurat Object
# -------------------------------
# Find and load the RDS file starting with "seuratObject"
rds_files <- list.files(path = dir_path, pattern = "^seuratObject.*\\.RDS$", full.names = TRUE)
if (length(rds_files) == 0) {
  stop("No RDS file starting with 'seuratObject' found in the directory.")
}
seuratObj <- readRDS(rds_files[1])
cat("Loaded RDS file:\n", rds_files[1], "\n\n")

# Optional: display dimensions and sample names
cat("Seurat object dimensions: ", nrow(seuratObj), " features x ", ncol(seuratObj), " cells\n")
cat("First few cell names:\n")
print(head(colnames(seuratObj)))
cat("\n")

# -------------------------------
# 4. Load the Metadata CSV File
# -------------------------------
# Find and load the CSV file starting with "NapariLayers"
csv_files <- list.files(path = dir_path, pattern = "^NapariLayers.*\\.csv$", full.names = TRUE)
if (length(csv_files) == 0) {
  stop("No CSV file starting with 'NapariLayers' found in the directory.")
}
metadata <- fread(csv_files[1]) %>% as.data.frame()
cat("Loaded CSV file:\n", csv_files[1], "\n\n")

# Optional: display dimensions and column names of metadata
cat("Metadata dimensions: ", nrow(metadata), " rows x ", ncol(metadata), " columns\n")
cat("Column names:\n")
print(colnames(metadata))
cat("\n")

# -------------------------------
# 5. Process the Metadata
# -------------------------------
# Identify fixed columns: UID, cell_ID, and any columns with "cell_type" in the name
fixed_cols <- c("UID", "cell_ID", grep("cell_type", colnames(metadata), value = TRUE))
# All other columns will be treated as boolean columns.
bool_cols <- setdiff(names(metadata), fixed_cols)

# Convert boolean columns from strings ("True"/"False") to logical values.
metadata[, bool_cols] <- lapply(metadata[, bool_cols, drop = FALSE], function(x) {
  tolower(x) == "true"
})

# Collapse boolean calls into a new meta feature called "SampleID".
# For each row, if a boolean column is TRUE and SampleID is still "Unknown",
# assign that column's name to SampleID.
metadata$SampleID <- "Unknown"
for (col in bool_cols) {
  metadata$SampleID <- ifelse(metadata[[col]] & metadata$SampleID == "Unknown",
                              col,
                              metadata$SampleID)
}

# For backward compatibility, create a Tissue column
metadata$Tissue <- metadata$SampleID

# Set row names of metadata to the cell_ID column
rownames(metadata) <- metadata$cell_ID

# Add the metadata to the Seurat object
seuratObj <- AddMetaData(seuratObj, metadata = metadata)

# -------------------------------
# 6. Write Output Files
# -------------------------------
# Write out the modified Seurat object to a new RDS file.
out_ser_file <- gsub(".RDS", "_Mod.RDS", rds_files[1])
saveRDS(seuratObj, out_ser_file)
cat("Modified Seurat object saved to:\n", out_ser_file, "\n\n")

# Write out the modified metadata to a new CSV file.
output_csv <- file.path(dir_path, "Modified_NapariLayers.csv")
write.csv(metadata, file = output_csv, row.names = FALSE)
cat("Modified metadata saved to:\n", output_csv, "\n")
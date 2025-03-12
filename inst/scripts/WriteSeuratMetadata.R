library(Seurat)
library(data.table)

files <- list.files(".",full.names = TRUE )

# identify the Seurat object
if(length(grep("seuratObject", files)) == 1) {
  seuratObj <- readRDS(files[grepl("seuratObject", files)])
} else if ( length(grep("Seurat", files)) > 1) {
  stop("Multiple Seurat objects found. Please remove the extra Seurat objects.")
} else {
  stop("No Seurat object found in the specified directory.")
}

#identify Seurat metadata containing the celltyping from InSituType
#the column names containing the cell type annotations start with RNA_nbclust and end with _1_clusters, but contain a random hash 
cell_type_columns <- colnames(seuratObj@meta.data)[grepl("RNA_nbclust", colnames(seuratObj@meta.data)) & 
                                                     !grepl("posterior_probability", colnames(seuratObj@meta.data))]
if (length(cell_type_columns) == 0) {
  stop("No cell type columns found in the metadata.")
}
#extract the relevant metadata
cell_metadata <- seuratObj@meta.data[, c("cell_ID", cell_type_columns), drop = FALSE] 
colnames(cell_metadata) <-c("cell_ID", paste0("cell_type_", 1:length(cell_type_columns)))

#write metadata to a file named _metadata.csv to be loaded in napari. 
data.table::fwrite(cell_metadata, "/work/StitchedImage/_metadata.csv")

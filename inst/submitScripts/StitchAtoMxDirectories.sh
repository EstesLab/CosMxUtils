#!/bin/bash
#usage: StitchAtoMxDirectories.sh
# This script will loop over all directories in the current working directory and 
# stitch the images in the CellStatsDir and RunSummary directories to be ingested by napari. 
# This script also writes a _metadata.csv file to each Stitched image directory, 
# which containing unsupervised clustering results.
set -e

PWD=$(pwd)

#pull the CosMxUtils image
srun apptainer --disable-cache pull NapariStitch.sif docker://ghcr.io/esteslab/naparistitch:nightly
NAPARISIF=${PWD}/NapariStitch.sif

#loop over directories 
subdirectories=$(ls -d $PWD/*/)
for dir in  ${subdirectories}
do
    #set up the directory variables
    dir=${dir%*/}
    WD=$dir
    HOME=`echo ~/`
    CELLSTATSDIR=$(find $dir -type d -name CellStatsDir)
    RUNSUMMARYDIR=$(find $dir -type d -name RunSummary)
    ANALYSISRESULTSDIR=$(find $dir -type d -name AnalysisResults)
    #make the output directory
    mkdir -p ${WD}/StitchedImage
    #get the script that writes the unsupervised clustering results.
    wget -O WriteSeuratMetadata.R https://raw.githubusercontent.com/EstesLab/CosMxUtils/refs/heads/main/inst/scripts/WriteSeuratMetadata.R
    #submit a stitching job and write a _metadata.csv file to each Stitched image directory containing unsupervised clustering results.
    sbatch \
         --job-name=StitchImages \
         --mem 8000 \
         --cpus-per-task=2 \
         --output=${dir}/stitching.log \
         --error=${dir}/stitching.error \
         --partition=batch \
         --time=0-36 \
         --chdir=$dir \
         apptainer exec \
            -B "${WD}:/work" \
            -B "${HOME}:/homeDir" \
            $NAPARISIF \
              /bin/bash -c \
                "stitch-images -i $CELLSTATSDIR -f $RUNSUMMARYDIR -o StitchedImage;
                read-targets $ANALYSISRESULTSDIR -o StitchedImage;
                Rscript --vanilla /work/WriteSeuratMetadata.R"
          #TODO: delete the original ATOMX exports. 
done

#clean cache
yes | apptainer cache clean



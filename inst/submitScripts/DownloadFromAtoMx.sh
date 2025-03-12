#!/bin/bash
# usage: DownloadFromAtoMx.sh [subdirectory]
# The subdirectory is the name of the subdirectory in the AtoMx SFTP server where the data is stored.
# If no subdirectory is provided, the script will download all directories currently on the AtoMx SFTP server, but will prompt the user. 
# In reality, there's probably not much there, but could be quite large amounts of data. 

set -e

SCRIPT=${1}.exp
wget -O $SCRIPT https://raw.githubusercontent.com/EstesLab/CosMxUtils/refs/heads/main/inst/scripts/sftp_get_all.exp
chmod +x $SCRIPT

if [[ -z $1 ]];then
        echo "No subdirectory provided. By default, ALL files Stephen has exported will be downloaded. Is that desired?\nEnter 'yes' below, or 'no' to cancel."
        read -p "Response:" response
        if [[ $response = 'yes' ]];then
                echo "Creating downloads directory to store downloads."
                mkdir downloads
                cd downloads
                sbatch \
                        --job-name="AtoMxDownloadAll" \
                        --mem 8000 \
                        --cpus-per-task=2 \
                        --output=downloadAll.log \
                        --error=downloadAll.error \
                        --partition=batch \
                        --time=0-36 \
                        --chdir=$PWD \
                        ../$SCRIPT
        elif [[ $response = 'no' ]];then
                echo "Set the subdirectory by executing this script again with the desired subdirectory as the first and only argument."
                exit 1
        else
                exit 1
        fi
else
        mkdir $1
        cd $1
        sbatch \
                        --job-name=$1 \
                        --mem 8000 \
                        --cpus-per-task=2 \
                        --output=$1.log \
                        --error=$1.error \
                        --partition=batch \
                        --time=0-36 \
                        --chdir=$PWD \
                        ../$SCRIPT $1
fi

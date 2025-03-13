FROM nvcr.io/nvidia/cuda-dl-base:25.01-cuda12.8-devel-ubuntu24.04
#trying a rather new nvidia base image, but we can probably go lighter if we need to.
#image size ~6GB
ARG DEBIAN_FRONTEND=noninteractive

#numpy==1.26.4 necessary because numpy 2.0 breaks like half of all python packages.
#the nanostring napari-cosmx wheel is probably going to need updating eventually (written 2/19/2025)
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    libgl1-mesa-dev \
    squashfs-tools \
    libseccomp-dev \
    libffi-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    pkg-config \
    git-all \
    wget \
    libbz2-dev \
    zlib1g-dev \
    python3-dev \
    r-base && \
    Rscript -e "install.packages(c('remotes', 'devtools', 'BiocManager', 'Seurat', 'data.table'), ask = FALSE, upgrade = 'always')" && \
    mkdir /Napari_Python && \
    cd /Napari_Python && \
    wget http://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz && \
    tar -zxvf Python-3.9.0.tgz && \
    cd Python-3.9.0 && \
    ./configure --prefix=/Napari_Python && \
    make && \
    make install && \
    /Napari_Python/bin/python3.9 -m pip install --upgrade pip && \
    /Napari_Python/bin/pip3 install numpy==1.26.4 && \
    /Napari_Python/bin/pip3 install "napari[all]" && \
    wget https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space/raw/refs/heads/Main/assets/napari-cosmx%20releases/napari_CosMx-0.4.17.0-py3-none-any.whl && \
    /Napari_Python/bin/pip3 install napari_CosMx-0.4.17.0-py3-none-any.whl && \
    /Napari_Python/bin/pip3 freeze | grep "napari_CosMx"

#add Napari_Python to path to find the stitching executables
ENV PATH "$PATH:/Napari_Python/bin/"

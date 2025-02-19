FROM nvcr.io/nvidia/cuda-dl-base:25.01-cuda12.8-devel-ubuntu24.04
#trying a rather new nvidia base image, but we can probably go lighter if we need to.
#image size ~6GB
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    pkg-config \
    git-all \
    wget \
    libbz2-dev \
    zlib1g-dev \
    python3-dev \
    libffi-dev && \
    mkdir /Napari_Python && \
    cd /Napari_Python && \
    wget http://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz && \
    tar -zxvf Python-3.9.0.tgz && \
    cd Python-3.9.0 && \
    ./configure --prefix=/Napari_Python && \
    make && \
    make install && \
    /Napari_Python/bin/pip3 install "napari[all]" && \
    wget https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space/raw/refs/heads/Main/assets/napari-cosmx%20releases/napari_CosMx-0.4.17.0-py3-none-any.whl && \
    /Napari_Python/bin/pip3 install napari_CosMx-0.4.17.0-py3-none-any.whl && \
    /Napari_Python/bin/pip3 freeze | grep "napari_CosMx"

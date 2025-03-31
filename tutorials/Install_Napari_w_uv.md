## Setting up Napari + CosMX Plugin using uv and Python 3.9

### Remove any old virtual environment

deactivate  
rm -rf napari-env

### Create a new virtual environment using Python 3.9 and uv

### Make sure Python 3.9 is installed:
brew install python@3.9

### Then create and activate the environment:
uv venv napari-env --python $(brew --prefix python@3.9)/bin/python3.9  
source napari-env/bin/activate

### Upgrade core tools and install numpy 1.26.4

uv pip install --upgrade pip setuptools wheel  
uv pip install numpy==1.26.4

### Install Napari with PyQt5 (to ensure GUI support)

uv pip uninstall napari -y  
uv pip install "napari[pyqt5]"

### Install the CosMX plugin

wget https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space/raw/refs/heads/Main/assets/napari-cosmx%20releases/napari_CosMx-0.4.17.3-py3-none-any.whl

### Assuming the wheel file is in the Downloads folder:
uv pip install ~/Downloads/napari_CosMx-0.4.17.3-py3-none-any.whl

### Launch Napari using a programmatic alias

### Since the standard CLI entry point was broken, use this workaround:
### Add the following line to ~/.zshrc or ~/.bashrc:
alias napari="python -c 'import napari; viewer = napari.Viewer(); napari.run()'"

### Then run:
napari

### This will open the Napari GUI.

### Notes:

- We use Python 3.9 because the CosMX plugin and vaex-core are not compatible with Python >=3.12.
- numpy==1.26.4 avoids breaking changes introduced in numpy 2.0.
- The standard CLI entry point for napari==0.5.6 is missing main.py, so we bypass it using a Python alias.
- uv is used for speed and reproducibility, but regular pip can be used as a fallback if needed.

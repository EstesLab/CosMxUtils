conda create --prefix /Path/to/your/env/anaconda3/napari-env python=3.9

conda activate /home/groups/ConradLab/Eisa/anaconda3/napari-env
pip install --upgrade pip
pip install numpy==1.26.4
pip install -U "napari[all]"
 
# pip install -U 'napari[all]'  # default choice
# pip install -U 'napari[pyqt5]'
# pip install -U 'napari[pyside2]'

pip install napari_console

pip install ipywidgets jupyterlab

wget https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space/raw/refs/heads/Main/assets/napari-cosmx%20releases/napari_CosMx-0.4.17.3-py3-none-any.whl
pip install napari_CosMx-0.4.17.3-py3-none-any.whl

python -c "import napari; print(napari.__version__)"



conda activate /Path/to/your/env/anaconda3/napari-env

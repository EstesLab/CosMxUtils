Napari Environment Setup Instructions
=======================================

Follow these steps to set up your Napari environment with Python 3.9 and the required packages.

1. Create a Conda Environment
-----------------------------
Run the following command, replacing /Path/to/your/env with your desired path:

    conda create --prefix /Path/to/your/env/anaconda3/napari-env python=3.9

2. Activate the Environment
---------------------------
Activate the environment with:

    conda activate /home/groups/ConradLab/Eisa/anaconda3/napari-env

3. Upgrade pip
--------------
Upgrade pip by running:

    pip install --upgrade pip

4. Install a Specific Version of NumPy
---------------------------------------
Install NumPy version 1.26.4 with:

    pip install numpy==1.26.4

5. Install Napari with All Optional Dependencies
-------------------------------------------------
Install Napari (with all optional dependencies) by running:

    pip install -U "napari[all]"

Alternatively, you can choose a specific GUI backend:

    # pip install -U 'napari[all]'  # default choice
    # pip install -U 'napari[pyqt5]'
    # pip install -U 'napari[pyside2]'

6. Install Napari Console
-------------------------
Install the Napari Console with:

    pip install napari_console

7. Install ipywidgets and JupyterLab
------------------------------------
Install these packages by running:

    pip install ipywidgets jupyterlab

8. Download and Install the CosMx Napari Plugin
------------------------------------------------
Download the wheel file with wget:

    wget https://github.com/Nanostring-Biostats/CosMx-Analysis-Scratch-Space/raw/refs/heads/Main/assets/napari-cosmx%20releases/napari_CosMx-0.4.17.3-py3-none-any.whl

Then install it with pip:

    pip install napari_CosMx-0.4.17.3-py3-none-any.whl

9. Verify Napari Installation
-----------------------------
Check that Napari is installed correctly by running:

    python -c "import napari; print(napari.__version__)"

10. (Optional) Re-Activate the Environment if Needed
------------------------------------------------------
If you need to reactivate the environment later, use:

    conda activate /Path/to/your/env/anaconda3/napari-env



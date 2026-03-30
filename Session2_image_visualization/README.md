# Image visualization

This document contains some instructions used in Section 2: Interactive image visualization.

## IMC raw data inspection using napari-imc

Extract the file `Patient/Patient4.mcd` from the archive `Patient4.zip` in `IMCWorkshop2026/data/cell_mode/raw` to a known location.

Launch napari using the command prompt (Windows) or the terminal (Mac OS, Linux):

    micromamba activate napari
    napari

In napari, click `File -> Open File(s)...` and open the file `Patient4.mcd` or drag&drop the file into the napari GUI.

Instructions on how to use napari-imc are given during the workshop.


## Using napari from within Python / Jupyter Lab

Launch Jupyter Lab within the `IMCWorkshop2026` directory using the command prompt (Windows) or the terminal (Mac OS, Linux):

    cd YOUR_PATH_TO/IMCWorkshop2026  # adapt as needed
    micromamba activate napari
    jupyter-lab
    
In Jupyter Lab, open the notebook `Session2_image_visualization/napari.ipynb`.

Instructions on how to use the notebook are given during the workshop.

# Image Visualization
## Lunching napari
Open a terminal and cd to the root directory of this repo and activate the _napari_ environment you created.

```bash
cd /path/to/IMCWorkshop2026
mamba activate napari
```

It is assumed that you have already downloaded the data and that is available in `IMCWorkshop2026/data`.

### From terminal
Simply use the `napari` comand in your terminal to lunch a GUI.
```bash
napari
```

### From python
Alternatively you can open a GUI from a python program.
```bash
python # this should open a python session in your terminal
```

```python
import napari
napari.Viewer()
```

### From Desktop
You can also download the _napari_ app from [their webpage](https://napari.org/stable/getting_started/installation.html#installation-bundle-conda) and lunch it as you would any other app.

## Loading an IMC image in napari
### From GUI
If you already have a GUI open you can simply click on the `File > Open File(s)…` and select an image from your device. 

For example:

```bash
napari # to open a GUI
```

Then `File > Open File(s)…` and select `data/cell_mode/img/Patient1_001.tiff`.

### From the terminal
You can specify the path to the image directly in the napari command and the GUI will open with the image loaded.

```bash
napari data/cell_mode/img/Patient1_001.tiff
```

### From python
```bash
python # this should open a python session in your terminal
```

```python
import napari, tifffile
img = tifffile.imread("data/cell_mode/img/Patient1_001.tiff")
napari.imshow(img)
```

## Define Layer Setting in python
To avoid setting the diplay settting manually everytime you can define them in a python script. Examples of how to do this are given in the `Session2_image_visualization/napari.ipynb` notebook. The examples in the notebook will be reviewed during the tutorial.


Open jupyter lab from your terminal and navigate to the notebook.

```bash
jupyter-lab
```

## napari-img
Open a napari GUI, install the napari-imc plugin load an mcd file. Detailed instructions during tutorial. 

```bash
napari  # to open a GUI
```
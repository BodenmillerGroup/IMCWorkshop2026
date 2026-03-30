# Image processing

This document contains the instructions used in *Session 1: Image processing*.

Please make sure you have cloned/downloaded an up-to-date version of this repository, completed the [setup instructions and downloaded the data](../Setup/README.md).

For questions or help, please employ the *steinbock* `--help` option (after step 2) or the [steinbock documentation](https://bodenmillergroup.github.io/steinbock/), or raise your hand.


# Pre-process cell mode images

## 1. Configuring steinbock

### Mac OS / Linux / SSH / Windows WSL

Define a `steinbock` alias:  

In the below command, adapt `YOUR_PATH_TO` to your actual path. e.g. in Windows WSL your home directory on C: is typically found here: `/mnt/c/Users/YOUR_USERNAME`  
For windows activate wsl first.

    alias steinbock="docker run --rm -v "/YOUR_PATH_TO/IMCWorkshop2026/data/cell_mode":/data -u $(id -u):$(id -g) ghcr.io/bodenmillergroup/steinbock:0.16.5"
    steinbock --version



Verify that the final output reads `steinbock, version 0.16.5`.


## 2. Configuring channels

Infer a *steinbock* panel file from raw IMC data:

    steinbock preprocess imc panel --unzip

Inspect the generated `panel.csv` file.

Delete the file and rename `panel_clean.csv` to `panel.csv`.


## 3. Pre-processing raw IMC data with hot-pixel filtering

Extract and pre-process IMC acquisitions:

    steinbock preprocess imc images --unzip --hpf 50

Inspect the `img` folder with the extracted `.tiff`image files.


## 4. Pre-processing raw IMC data without hot-pixel filtering

Extract and pre-process IMC acquisitions:

    steinbock preprocess imc images --unzip --imgout img_raw

Inspect the `img_raw` folder with the extracted `.tiff`image files.


## 5. Segmenting cells using DeepCell/Mesmer

Perform Mesmer whole-cell segmentation:

    steinbock segment deepcell --app mesmer --minmax

Inspect the generated cell masks in the `masks` directory.


## 6. Measuring cell intensities

Aggregate pixel intensities per cell & marker:

    steinbock measure intensities --aggr mean

Inspect the generated single-cell data in the `intensities` directory.


## 7. Measuring cell morphology

Measure morphological properties per cell:

    steinbock measure regionprops

Inspect the generated single-cell data in the `regionprops` directory.


## 8. Finding cell neighbors

Identify cells in spatial proximity:

    steinbock measure neighbors --type expansion --dmax 4

Inspect the generated cell pair lists in the `neighbors` directory.


# Pre-process compensation slide images for new XTi machines

## 1. Configuring steinbock

### Mac OS / Linux / SSH / Windows WSL

Define a `steinbock` alias:

    alias steinbock="docker run --rm -v "/YOUR_PATH_TO/IMCWorkshop2026/data/compensation":/data -u $(id -u):$(id -g) ghcr.io/bodenmillergroup/steinbock:0.16.5"
    steinbock --version

In above command, adapt `YOUR_PATH_TO` to your actual path.

Verify that the final output reads `steinbock, version 0.16.5`.


## 2. Extracting panel file

Infer a *steinbock* panel file from raw IMC data:

    steinbock preprocess imc panel --unzip

The extracted panel from the mcd files containes a channel name that is not in agreement with the downstream spillover processing using CATALYST. The nomenclature for meta-mass combinations generally should be "MetalMass" style. In the panel we can see that for the Argon dimer channel the name is "ArAr80". We will change this to "Ar80" and save the panel. 

## 3. Pre-processing raw compensation data with hot-pixel filtering

Extract and pre-process IMC acquisitions:

    steinbock preprocess imc images --unzip --hpf 50

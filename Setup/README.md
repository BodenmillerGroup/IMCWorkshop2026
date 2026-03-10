# Software setup

### Requirements

For this workshop the following technical prerequisites are required:
1. At least 20+ GB free disk space on your device
2. 8 GB RAM minimum, 16 GB recommended
3. Apple Silicon, Intel/AMD Windows or modern Linux OS

**Note:** If you can't provide some of these requirements, please reach out to victor.ibanez@uzh.ch prior to the workshop to find another solution or join the troubleshooting session on the beginning of the first day.**


## Docker
For most of the sessions we use the a Docker container with all the necessary packages and Rstudio- as well as Jupyter server. For this, please install [Docker Desktop](https://docs.docker.com/get-docker/) (Mac OS, Windows) or [Docker Server/Engine](https://docs.docker.com/engine/install/#server) (Linux). Depending on your operating system, additional configuration steps may be necessary as outlined below.

### Configuring Docker Desktop for Mac

Increase the memory that Docker Desktop is allowed to use as described [here](https://docs.docker.com/desktop/settings/mac/#advanced) (Docker Preferences --> Resources --> Advanced --> Memory). To avoid problems during the workshop, we recommend to set this to roughly 80% of the maximum available system memory.

### Configuring Docker Desktop for Windows

Make sure to NOT skip step 5 of the interactive installation instructions (adding your user to the *docker-users* group, if necessary).

Docker Desktop can run in either *Hyper-V mode* or in *WSL 2 mode*. To check/choose in which mode Docker Desktop is running, refer to the preferences menu as described [here](https://docs.docker.com/desktop/settings/windows/#general) (Docker Preferences --> General --> Use the WSL 2 based engine). In general, we recommend to run Docker Desktop in *WSL 2 mode* (i.e., with the "Use the WSL 2 based engine" checkbox ticked).

If Docker Desktop is running in *Hyper-V mode* (i.e., with the "Use the WSL 2 based engine" checkbox grayed out or NOT ticked), increase the memory that Docker Desktop is allowed to use as described [here](https://docs.docker.com/desktop/settings/windows/#advanced) (Docker Preferences --> Resources --> Advanced --> Memory). To avoid problems during the workshop, we recommend to set this to roughly 80% of the maximum available system memory.

### Configuring Docker Server/Engine for Linux

To be able to run ``docker`` as non-root user, follow the [Docker Engine post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).


### Running the docker container
Once you installed Docker Desktop and it is open and running, go to a terminal or shell and pull and run the container:

1. Open a [Command Prompt (Windows)](https://www.wikihow.com/Open-the-Command-Prompt-in-Windows) or Terminal ([Mac OS](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Terminal%20for%20me-,Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), Linux).

2. pull the docker container (*Note:* you will need internet access and it will take up to an hour to download the container?)
```bash
   docker pull ghcr.io/bodenmillergroup/imc-workshop26:latest
   ```

3. After that, run the container: 

```bash
   docker run -it \
  -p 8787:8787 \
  -p 8888:8888 \
  -v "$(pwd)":/home/rstudio/work \
  -w /home/rstudio/work \
  --name imc-workshop \
  ghcr.io/bodenmillergroup/imc-workshop26:latest
  ```

4. To open either Jupyter or Rstudio, just type in ```localhost:8888``` or  ```localhost:8787``` respectively in any browser of your choice and it will open up there automatically with a fixed working directory (ImagingWorkshop2026).
**Note:** For Rstudio server you will be prompted a username and password, which are:
- Username: ```rstudio```
- Password: ```rstudio```


## Mamba

In session 2, we introduce several alternatives for viewing multi-channel images. Among these alternatives, we present the [napari](https://napari.org) image viewer for Python and the [napari-imc](https://github.com/BodenmillerGroup/napari-imc) plugin. In the workshop, we use [mamba](https://mamba.readthedocs.io/en/latest/index.html) environments for installing both napari and napari-imc as follows:

1. [Install Micromamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html).

2. Open a [Command Prompt (Windows)](https://www.wikihow.com/Open-the-Command-Prompt-in-Windows) or Terminal ([Mac OS](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Terminal%20for%20me-,Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), Linux).

3. Execute the following commands:  
   ```
   micromamba create -n napari -c conda-forge python=3.11 napari pyqt jupyterlab ipykernel napari-imc tifffile pandas
   micromamba activate napari
   ```
   
6. Execute ``jupyter lab`` and verify that jupyter-lab opens.

7. Execute ``napari`` and verify that napari opens.

Other tools for interactive image visualization introduced during the workshop include the ([MCDViewer](https://www.standardbio.com/products-services/software)) specifically for imaging mass cytometry as well as [QuPath](https://qupath.github.io/) and [ImageJ/FIJI](https://imagej.net/software/fiji/)) for more general multiplexed image visualization.


**Note:** Please join the troubleshooting session on the beginning of the first day if you experience issues installing any of the software.
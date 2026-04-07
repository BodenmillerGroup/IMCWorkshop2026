# Software setup

### Requirements

For this workshop the following technical prerequisites are required:
1. At least 50+ GB free disk space on your device
2. 8 GB RAM minimum, 16 GB recommended
3. Apple Silicon, Intel/AMD Windows 10 but ideally Windows 11 or modern Linux OS

**Note:** If you can't provide some of these requirements, please reach out to victor.ibanez@uzh.ch prior to the workshop to find another solution or join the troubleshooting session on the beginning of the first day.**
**PowerShell** is the recommended terminal in Windows which should be standardly available in Win 11.



## Downloading the code

To download the code you can clone the current repository via

```
git clone https://github.com/BodenmillerGroup/IMCWorkshop2026.git
```

or you can click the `Code` > `Download ZIP` button.

## Docker

For most of the sessions we use two Docker containers (steinbock container for preprocessing and rstudio container for data analysis) with all the necessary packages included. For this, please install [Docker Desktop](https://docs.docker.com/get-docker/) (Mac OS, Windows) or [Docker Server/Engine](https://docs.docker.com/engine/install/#server) (Linux). Depending on your operating system, additional configuration steps may be necessary as outlined below.

### Configuring Docker Desktop for Mac

Increase the memory that Docker Desktop is allowed to use as described [here](https://docs.docker.com/desktop/settings/mac/#advanced) (Docker Preferences --> Resources --> Advanced --> Memory). To avoid problems during the workshop, we recommend to set this to roughly 80% of the maximum available system memory.

### Configuring Docker Desktop for Windows 11

Make sure to NOT skip step 5 of the interactive installation instructions (adding your user to the *docker-users* group, if necessary).

Docker Desktop can run in either *Hyper-V mode* or in *WSL 2 mode*. To check/choose in which mode Docker Desktop is running, refer to the preferences menu as described [here](https://docs.docker.com/desktop/settings/windows/#general) (Docker Preferences --> General --> Use the WSL 2 based engine). In general, we recommend to run Docker Desktop in *WSL 2 mode* (i.e., with the "Use the WSL 2 based engine" checkbox ticked).

If Docker Desktop is running in *Hyper-V mode* (i.e., with the "Use the WSL 2 based engine" checkbox grayed out or NOT ticked), increase the memory that Docker Desktop is allowed to use as described [here](https://docs.docker.com/desktop/settings/windows/#advanced) (Docker Preferences --> Resources --> Advanced --> Memory). To avoid problems during the workshop, we recommend to set this to roughly 80% of the maximum available system memory.

**Ideal setup for Docker on Win 11:**  
Install wsl via terminal (needs administrator rights):
`wsl.exe --install Ubuntu24.04`  
Restart the computer and open a terminal. then type:  
`wsl`  
set password.  
Download docker desktop (x86_64)  
install docker desktop (needs administrator rights) check WSL backend and also allow windows containers to be used.  
open docker desktop -> generate account.  
Go to settings -> Resources -> WSL integration and select: "Enable integration with my default WSL distro". you should see your Ubuntu24.04 which you should also activate.  

Note: possibly Docker Desktop will require Server Service to be enabled. If required open a powershell terminal as administrator and run the following two commands:
```bash
   Set-Service -Name LanmanServer -StartupType Automatic 
   Start-Service LanmanServer 
   ```
You have now set up WSL and Docker!  
**Linux commands can now be run on your windows terminal after activating WSL in the terminal.**

### Configuring Docker Server/Engine for Linux

To be able to run ``docker`` as non-root user, follow the [Docker Engine post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).


### Running the docker container
Once you installed Docker Desktop and it is open and running, go to a terminal or shell and pull and run the containers for rstudio and steinbock:

1. Open a [PowerShell terminal (Windows)] and type `wsl` or Terminal ([Mac OS](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Terminal%20for%20me-,Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), Linux).

2. pull the docker containers (*Note:* you will need internet access and it can take quite some time to download the containers (depending on your internet connection))
```bash
   docker pull ghcr.io/bodenmillergroup/imc-workshop26-rstudio:latest
   docker pull ghcr.io/bodenmillergroup/steinbock:0.16.5
   ```
For mac silicon computers (M1-M4):
```bash
   docker pull ghcr.io/bodenmillergroup/imc-workshop26-rstudio:latest
   docker pull ghcr.io/bodenmillergroup/steinbock:0.16.5-cellpose
   ```

3. navigate into the workshop folder with:
```bash
   cd YOUR_PATH_TO/IMCWorkshop2026
   ```
change ```YOUR_PATH_TO``` to your actual path where to where you cloned the github repo or extracted the downloaded github zipped repo.

4. After that, run the container:  

```bash
   docker run -it \
  -d \
  -p 8787:8787 \
  -v "$(pwd)":/home/rstudio/work \
  -w /home/rstudio/work \
  --name imc-workshop-rstudio \
  ghcr.io/bodenmillergroup/imc-workshop26-rstudio:latest
  ```

Note: if you have administrator right conflicts in wsl you may have to add the ubuntu user to the docker group. This can be done in wsl via:  
`sudo usermod -aG docker $USER`.  
Furthermore, for Windows it is possible to start the container via docker desktop. For that, go to the `Images` tab (you should see the image that we pulled under step 2 above). Hit the `run` botton to start the container from the image. you will be prompted for some optional settings. select the following:  
name (optional): e.g. imc-workshop2026-rstudio  
Host port 1: 8787   
Volumes host path: YOUR_PATH_TO/IMCWorkshop2026  
Container path: /home/rstudio/work/  
Hit run. The running container should now also appear under `Containers`. You can now stop and restart this specific container from the `Containers` tab.

5. To open Rstudio, just type in  ```localhost:8787``` in any browser of your choice and it will open up there automatically with a fixed working directory (ImagingWorkshop2026).
**Note:** For Rstudio server you will be prompted a username and password, which are:
- Username: ```rstudio```
- Password: ```imcworkshop26```  

Once this docker container is configured you can activate or deactivate it as you wish using:  
```bash
   docker stop imc-workshop-rstudio
   docker start imc-workshop-rstudio
```

## Mamba

In session 2, we introduce several alternatives for viewing multi-channel images. Among these alternatives, we present the [napari](https://napari.org) image viewer for Python and the [napari-imc](https://github.com/BodenmillerGroup/napari-imc) plugin. In the workshop, we use [mamba](https://mamba.readthedocs.io/en/latest/index.html) environments for installing both napari and napari-imc as follows:

1. Open a [Command Prompt (Windows)](https://www.wikihow.com/Open-the-Command-Prompt-in-Windows) or Terminal ([Mac OS](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Terminal%20for%20me-,Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), Linux).

2. [Install Micromamba](https://mamba.readthedocs.io/en/latest/installation/micromamba-installation.html).
Follow the instructions for your operating system. **IMPORTANTLY, set the $PROFILE variable reasonable: e.g. "C:/Users/YOUR_USER_NAME/micromamba"**  

Note: on Windows for administration managed computers it is possible that scripts via powershell are disabled or that your powershell profile home is under OneDrive which may restrict usage. After following the installation instructions of micromamba for Windows, run the following commands if you get an error that points in this direction:

   ```bash
      Set-ExecutionPolicy -Scope CurrentUser
      remotesigned 
   ```

3. Execute the following commands:  
   ```
   micromamba create -n napari -c conda-forge python=3.11 napari pyqt jupyterlab ipykernel napari-imc tifffile pandas
   micromamba activate napari
   ```
   
4. Execute 
   ```
   jupyter lab
   ```
   and verify that jupyter-lab opens.

5. Execute 
   ```
   napari
   ``` 
   and verify that napari opens.

Other tools for interactive image visualization introduced during the workshop include the ([MCDViewer](https://www.standardbio.com/products-services/software)) specifically for imaging mass cytometry as well as [QuPath](https://qupath.github.io/) and [ImageJ/FIJI](https://imagej.net/software/fiji/)) for more general multiplexed image visualization.



## Data download

1. Open a [Command Prompt (Windows)](https://www.wikihow.com/Open-the-Command-Prompt-in-Windows) or Terminal ([Mac OS](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Terminal%20for%20me-,Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), Linux).

2. navigate into the workshop folder with:
```bash
   cd YOUR_PATH_TO/IMCWorkshop2026
   ```
change ```YOUR_PATH_TO``` to your actual path where to where you cloned the github repo or extracted the downloaded github zipped repo.

3. pull the IMC workshop data from Zenodo with:
```bash
   wget https://zenodo.org/records/19184908/files/data.zip
   unzip data.zip
   ```
or go to https://zenodo.org/records/19184908 and download the folder into ```YOUR_PATH_TO/IMCWorkshop2026``` and unzip it there with double-click on the folder.


**Note:** Please join the troubleshooting session on the beginning of the first day if you experience issues installing any of the software.

# Docker Setup for Imaging Mass Cytometry Workshop 2026

This repository contains a Docker environment for the Imaging Mass Cytometry (IMC) Workshop 2026. The Docker setup provides a complete analysis environment with R, Python, and specialized imaging tools.

## Quick Start

1. **Build the Docker image:**
   ```bash
   docker build -t imc-workshop-2026 .
   ```

2. **Run the container:**
   ```bash
   docker run -p 8787:8787 -p 8888:8888 imc-workshop-2026
   ```

3. **Access the services:**
   - **RStudio Server**: http://localhost:8787 (username: `rstudio`, password: `rstudio`)
   - **Jupyter Lab**: http://localhost:8888 (no authentication required)

## Prerequisites

- **Docker**: Install Docker Desktop for your operating system from [docker.com](https://www.docker.com/products/docker-desktop)
- **System Requirements**: 
  - At least 8GB RAM recommended
  - 10GB free disk space for the Docker image
  - x86_64 or ARM64 architecture support

## Container Overview

The Docker container is based on `bioconductor/bioconductor_docker:RELEASE_3_22` and includes:

### R Environment
- **Base**: Bioconductor 3.22 with R
- **RStudio Server**: Web-based R IDE
- **Key R packages**:
  - CATALYST, scater, imcRtools, cytomapper
  - tidyverse, ggplot2, pheatmap, viridis
  - Rphenograph, lisaClust, spicyR
  - dittoSeq, batchelor, bluster, scran

### Python Environments
Two separate Python 3.11 environments managed by micromamba:

#### py-imc (IMC Analysis Tools)
- **steinbock**: IMC preprocessing and analysis
- **cellpose**: Cell segmentation
- **instanseg-torch**: Instance segmentation
- **Standard libraries**: numpy, scipy, pandas, scikit-image, scikit-learn

#### py-denoise (Image Denoising)
- **IMC_Denoise**: Deep learning-based image denoising
- **TensorFlow CPU**: Machine learning framework

### Jupyter Lab
- Integrated Jupyter Lab environment
- Two Python kernels available:
  - "Python (IMC tools)" - py-imc environment
  - "Python (IMC denoise)" - py-denoise environment

## Detailed Usage

### Building the Image

```bash
# Build with default settings
docker build -t imc-workshop-2026 .

# Build with custom tag
docker build -t my-imc-analysis:latest .

# Build and see detailed output
docker build --progress=plain -t imc-workshop-2026 .
```

### Running the Container

#### Basic Usage
```bash
# Run with port mapping
docker run -p 8787:8787 -p 8888:8888 imc-workshop-2026
```

#### Advanced Usage
```bash
# Run with volume mounting for data persistence
docker run -it \
  -p 8787:8787 \
  -p 8888:8888 \
  -v "$(pwd)":/home/rstudio/work \
  -w /home/rstudio/work \
  --name imc-workshop \
  imc-workshop26:test

# Run in detached mode
docker run -d \
  -p 8787:8787 \
  -p 8888:8888 \
  --name imc-workshop \
  imc-workshop-2026

# Run with custom memory limits
docker run \
  -p 8787:8787 \
  -p 8888:8888 \
  --memory="8g" \
  --cpus="4" \
  imc-workshop-2026
```

### Container Management

```bash
# List running containers
docker ps

# Stop the container
docker stop imc-workshop

# Start stopped container
docker start imc-workshop

# Remove container
docker rm imc-workshop

# View logs
docker logs imc-workshop
```

## Working with Data

### Volume Mounting
To persist your work and access local data files:

```bash
docker run \
  -p 8787:8787 \
  -p 8888:8888 \
  -v /path/to/your/project:/home/rstudio/work \
  imc-workshop-2026
```

### File Transfer
Copy files to/from running container:

```bash
# Copy file to container
docker cp myfile.txt imc-workshop:/home/rstudio/work/

# Copy file from container
docker cp imc-workshop:/home/rstudio/work/results.csv ./
```

## Convenience Commands

The container includes several convenience wrapper scripts:

```bash
# Access Python IMC environment
python-imc your_script.py

# Access Python denoise environment  
python-denoise your_script.py

# Run cellpose directly
cellpose --dir /path/to/images

# Run steinbock directly
steinbock_py preprocess imc images

# Test IMC_Denoise installation
imc_denoise_py
```

## Troubleshooting

### Common Issues

1. **Port already in use**:
   ```bash
   # Use different ports
   docker run -p 8790:8787 -p 8889:8888 imc-workshop-2026
   ```

2. **Out of memory errors**:
   ```bash
   # Increase memory limit
   docker run --memory="16g" -p 8787:8787 -p 8888:8888 imc-workshop-2026
   ```

3. **Permission issues with mounted volumes**:
   ```bash
   # Fix ownership (Linux/macOS)
   sudo chown -R 1000:1000 /path/to/your/data
   ```

### Accessing Container Shell
```bash
# Get shell access to running container
docker exec -it imc-workshop bash

# Run container with shell (for debugging)
docker run -it --entrypoint bash imc-workshop-2026
```

### Checking Package Installation
```bash
# Test R packages
docker run --rm imc-workshop-2026 R -e "library(CATALYST); library(imcRtools)"

# Test Python packages
docker run --rm imc-workshop-2026 python-imc -c "import steinbock, cellpose; print('OK')"
```

## Development and Customization

### Modifying the Environment

1. **Add R packages**: Edit `install_r_packages.R`
2. **Add Python packages**: Modify the pip install commands in `DOCKERFILE`
3. **Change startup behavior**: Edit `start.sh`

### Rebuilding After Changes
```bash
# Clean build (no cache)
docker build --no-cache -t imc-workshop-2026 .

# Remove old images
docker image prune -f
```

## File Structure

```
├── DOCKERFILE          # Main container definition
├── install_r_packages.R # R package installation script
├── start.sh            # Container startup script
└── DOCKER.md          # This documentation
```

## Support

- **Docker Issues**: Check Docker Desktop documentation
- **R Package Issues**: Verify Bioconductor installation
- **Python Package Issues**: Check micromamba environment activation
- **Memory Issues**: Increase Docker Desktop memory allocation

## Container Architecture

The container exposes two ports:
- **8787**: RStudio Server (R analysis)
- **8888**: Jupyter Lab (Python analysis)

# syntax=docker/dockerfile:1.7
FROM bioconductor/bioconductor_docker:RELEASE_3_22

SHELL ["/bin/bash", "-lc"]

ENV DEBIAN_FRONTEND=noninteractive
ENV OTEL_SDK_DISABLED=true
ENV OTEL_TRACES_EXPORTER=none
ENV OTEL_METRICS_EXPORTER=none
ENV OTEL_LOGS_EXPORTER=none
ENV MAMBA_ROOT_PREFIX=/opt/micromamba
ENV PATH=/opt/micromamba/bin:$PATH

# ---- System deps ----
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git \
    build-essential pkg-config \
    rstudio-server \
    libssl-dev libcurl4-openssl-dev libxml2-dev \
    libtiff5-dev \
    libgit2-dev \
    libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libjpeg-dev \
    libglpk-dev \
    libhdf5-dev \
    libprotobuf-dev protobuf-compiler \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- RStudio user ----
RUN id -u rstudio >/dev/null 2>&1 || useradd -m -s /bin/bash rstudio \
    && echo "rstudio:rstudio" | chpasswd

# ---- Micromamba ----
RUN arch="$(uname -m)"; \
    if [ "$arch" = "x86_64" ]; then mm_arch="64"; \
    elif [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then mm_arch="aarch64"; \
    else echo "Unsupported arch: $arch" && exit 1; fi; \
    curl -Ls "https://micro.mamba.pm/api/micromamba/linux-${mm_arch}/latest" \
    | tar -xvj bin/micromamba \
    && mv bin/micromamba /usr/local/bin/micromamba

# ---- Python env: IMC tools ----
RUN --mount=type=cache,target=/opt/micromamba/pkgs \
    micromamba create -y -n imc -c conda-forge \
    python=3.11 pip \
    numpy scipy pandas scikit-image scikit-learn \
    tifffile imagecodecs \
    libstdcxx-ng libgcc-ng \
    && micromamba clean -a -y

# ---- NEW: napari install needed for CLI in steinbock
RUN micromamba install -n imc -c conda-forge -y napari pyqt

RUN micromamba run -n imc pip install --no-cache-dir \
    "steinbock[imc,cellpose]" \
    "cellpose" \
    "instanseg-torch" \
    "jupyterlab" \
    "ipykernel"

# ---- Python env: IMC_Denoise ----
RUN --mount=type=cache,target=/opt/micromamba/pkgs \
    micromamba create -y -n denoise -c conda-forge \
    python=3.11 pip \
    numpy scipy pandas \
    tensorflow-cpu \
    && micromamba clean -a -y

RUN micromamba run -n denoise pip install --no-cache-dir \
    "git+https://github.com/PENGLU-WashU/IMC_Denoise.git" \
    "ipykernel"

ENV LD_LIBRARY_PATH=/opt/micromamba/envs/imc/lib:/opt/micromamba/envs/denoise/lib:${LD_LIBRARY_PATH}

RUN R -q -e 'options(repos=c(CRAN="https://cloud.r-project.org")); \
    if (!requireNamespace("BiocManager", quietly=TRUE)) install.packages("BiocManager"); \
    install.packages("https://cran.r-project.org/src/contrib/Archive/BH/BH_1.75.0-0.tar.gz", repos=NULL, type="source"); \
    BiocManager::install(c("RProtoBufLib","Rhdf5lib"), ask=FALSE, update=TRUE); \
    BiocManager::install("cytolib", ask=FALSE, update=TRUE, Ncpus=1); \
    cat("cytolib installed:", requireNamespace("cytolib", quietly=TRUE), "\n"); \
    if (!requireNamespace("cytolib", quietly=TRUE)) quit(status=1)'

# ---- R/Bioconductor packages ----
COPY install_r_packages.R /tmp/install_r_packages.R
RUN Rscript /tmp/install_r_packages.R

# ---- Convenience wrappers ----
RUN printf '#!/usr/bin/env bash\nexec micromamba run -n imc python "$@"\n' > /usr/local/bin/python-imc \
    && printf '#!/usr/bin/env bash\nexec micromamba run -n denoise python "$@"\n' > /usr/local/bin/python-denoise \
    && printf '#!/usr/bin/env bash\nexec micromamba run -n imc cellpose "$@"\n' > /usr/local/bin/cellpose \
    && printf '#!/usr/bin/env bash\nexec micromamba run -n imc steinbock "$@"\n' > /usr/local/bin/steinbock_py \
    && printf '#!/usr/bin/env bash\nexec micromamba run -n denoise python -c "import IMC_Denoise; print(\"IMC_Denoise OK\")"\n' > /usr/local/bin/imc_denoise_py \
    && chmod +x /usr/local/bin/python-imc /usr/local/bin/python-denoise /usr/local/bin/cellpose /usr/local/bin/steinbock_py /usr/local/bin/imc_denoise_py

# ---- Smoke tests ----
RUN micromamba run -n imc python -c "import steinbock, cellpose, instanseg; print('imc OK')" \
    && micromamba run -n denoise python -c "import tensorflow as tf; print('TF OK', tf.__version__)" \
    && micromamba run -n denoise python -c "import IMC_Denoise; print('IMC_Denoise OK')" \
    && R -q -e "library(CATALYST); library(scater); library(imcRtools); library(cytomapper); library(Rphenograph); cat('R OK\\n')"

# ---- Jupyter kernels ----
RUN micromamba run -n imc python -m ipykernel install \
    --name imc \
    --display-name "Python (IMC tools)"

RUN micromamba run -n denoise python -m ipykernel install \
    --name denoise \
    --display-name "Python (IMC denoise)"

EXPOSE 8787
EXPOSE 8888

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
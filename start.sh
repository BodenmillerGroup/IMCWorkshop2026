#!/usr/bin/env bash
set -e

mkdir -p /home/rstudio/work

/usr/lib/rstudio-server/bin/rserver --server-daemonize=1

exec micromamba run -n steinbock jupyter lab \
  --ip=0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --ServerApp.root_dir=/home/rstudio/work \
  --ServerApp.token='' \
  --ServerApp.password=''
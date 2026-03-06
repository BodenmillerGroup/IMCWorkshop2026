options(error = function() {
  traceback(2)
  quit(status = 1)
})

tryCatch({

  options(repos = c(CRAN = "https://cloud.r-project.org"))
  N <- max(1L, parallel::detectCores() - 1L)

  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", Ncpus = N)
  }

  message("\n\n===== Installing pinned BH =====\n")
  tryCatch({
    install.packages(
      "https://cran.r-project.org/src/contrib/Archive/BH/BH_1.75.0-0.tar.gz",
      repos = NULL,
      type = "source"
    )
  }, error = function(e) {
    message("\n\n***** FAILED installing pinned BH *****\n", conditionMessage(e))
    quit(status = 1)
  })

  message("\n\n===== Installing: RProtoBufLib, Rhdf5lib, cytolib =====\n")
  tryCatch({
    BiocManager::install(
      c("RProtoBufLib", "Rhdf5lib", "cytolib"),
      ask = FALSE,
      update = TRUE,
      Ncpus = N
    )
  }, error = function(e) {
    message("\n\n***** FAILED installing RProtoBufLib/Rhdf5lib/cytolib *****\n",
            conditionMessage(e))
    quit(status = 1)
  })

  if (!requireNamespace("cytolib", quietly = TRUE)) {
    message("\n\n***** cytolib is still missing after install *****\n")
    quit(status = 1)
  }

  pkgs <- c(
    "pheatmap", "viridis", "zoo", "devtools", "tiff",
    "distill", "openxlsx", "ggrepel", "patchwork", "mclust",
    "RColorBrewer", "uwot", "Rtsne", "cowplot", "kohonen",
    "caret", "randomForest", "ggridges", "gridGraphics",
    "scales", "CATALYST", "scuttle", "scater",
    "dittoSeq", "tidyverse", "batchelor",
    "bluster", "scran", "lisaClust", "spicyR", "imcRtools",
    "cytomapper", "imcdatasets"
  )

  message("\n\n===== Installing main package set =====\n")
  tryCatch({
    BiocManager::install(pkgs, ask = FALSE, update = TRUE, Ncpus = N)
  }, error = function(e) {
    message("\n\n***** FAILED installing main package set *****\n",
            conditionMessage(e))
    quit(status = 1)
  })

  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools", Ncpus = N)
  }

  message("\n\n===== Installing: Rphenograph =====\n")
  tryCatch({
    devtools::install_github("i-cyto/Rphenograph")
  }, error = function(e) {
    message("\n\n***** FAILED installing Rphenograph *****\n",
            conditionMessage(e))
    quit(status = 1)
  })

  must_have <- c("CATALYST", "scater", "imcRtools", "cytomapper", "Rphenograph")
  missing <- must_have[!vapply(must_have, requireNamespace, logical(1), quietly = TRUE)]

  if (length(missing)) {
    message("Missing packages after install: ", paste(missing, collapse = ", "))
    quit(status = 1)
  }

  message("\n\nReached end of install_r_packages.R successfully.\n")
  quit(status = 0)

}, error = function(e) {
  message("\n\nFATAL ERROR:\n", conditionMessage(e))
  traceback(2)
  quit(status = 1)
})
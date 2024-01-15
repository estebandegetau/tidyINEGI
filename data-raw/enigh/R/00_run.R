#### tidyinegi #################################################################
#'
#' @name 00_run.R
#'
#' @description
#' Run all scripts in the data-raw folder to transform raw ENIGH data from
#' INEGI into analysis-ready data sets.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-09
#'
#### Run #######################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here)

#---- Setup --------------------------------------------------------------------

.year <- 2022

# Open data
._01_unzip            <- 1
._02_rename_dirs      <- 1

# Build meta data
._01_get_var_labs     <- 0
._02_get_val_labs     <- 0
._03_build_metadata   <- 0

# Clean
._01_set_labels       <- 0

#---- Run ----------------------------------------------------------------------

# 1. Open data -----------------------------------------------------------------

# 1.1 Unzip data
if (._01_unzip) {
  source(here::here("data-raw", "enigh", "R", "01_open_data", "01_unzip.R"),
         encoding = "UTF-8")
}

# 1.2 Rename directories
if (._02_rename_dirs) {
  source(
    here::here("data-raw", "enigh",  "R", "01_open_data", "02_rename_dirs.R"),
    encoding = "UTF-8"
  )
}

# 2. Build meta data -----------------------------------------------------------

# 2.1 Get variable labels
if (._01_get_var_labs) {
  source(
    here::here(
      "data-raw",
      "enigh",
      "R",
      "02_build_meta",
      "01_get_variable_labels.R"
    ),
    encoding = "UTF-8"
  )
}

# 2.2 Get value labels
if (._02_get_val_labs) {
  source(
    here::here(
      "data-raw",
      "enigh",
      "R",
      "02_build_meta",
      "02_get_value_labels.R"
    ),
    encoding = "UTF-8"
  )
}

# 2.3 Build metadata
if (._03_build_metadata) {
  source(
    here::here(
      "data-raw",
      "enigh",
      "R",
      "02_build_meta",
      "03_build_metadata.R"
    ),
    encoding = "UTF-8"
  )
}

# 3. Clean ---------------------------------------------------------------------

# 3.1 Set labels
if (._01_set_labels) {
  source(
    here::here("data-raw", "enigh", "R", "03_clean", "01_set_labels.R"),
    encoding = "UTF-8"
  )
}


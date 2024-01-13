#### tidyinegi #################################################################
#'
#' @name 03_build_metadata.R
#'
#' @description Build metadata for ENIGH data.
#'              Includes labels for variables and values.
#'              Run through 00_run.R.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-12
#'
#### Build metadata ############################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools)

load_all()

#---- Load data sets -----------------------------------------------------------

year <- .year |> as.character()

data_sets <- list_data_sets(year)

descriptions <- read_inegi_csv(
  here::here(
    "data-raw",
    "enigh",
    "data",
    "02_open",
    year,
    "indice.csv"
  ),
  skip = 2
) |>
  rename(
    data_set = 1,
    description = 2
  ) |>
  mutate(data_set = clean_dataset_names(data_set))

load(here(
  "data-raw",
  "enigh",
  "data",
  "99_meta",
  year,
  "enigh_catalogues.RData"
))

load(here(
  "data-raw",
  "enigh",
  "data",
  "99_meta",
  year,
  "enigh_var_labels.RData"
))

#---- Build metadata -----------------------------------------------------------

enigh_metadata <- data_sets |>
  left_join(descriptions, by = "data_set") |>
  left_join(enigh_var_labels, by = "data_set") |>
  left_join(enigh_catalogues, by = "data_set")


#---- Save ---------------------------------------------------------------------

assign(str_c("enigh_metadata_", year), enigh_metadata)

save(
  list = str_c("enigh_metadata_", year),
  file = here(
    "data-raw",
    "enigh",
    "data",
    "99_meta",
    year,
    str_c("enigh_metadata_", year, ".RData")
  )
)


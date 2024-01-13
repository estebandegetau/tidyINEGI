#### tidyenigh #################################################################
#'
#' @name 02_get_value_labels.R
#'
#' @description Get value labels for ENIGH data using
#'    `tidyinegi::get_enigh_val_labels()`. Run through 00_run.R.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-12
#'
#### Get value labels ##########################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools)

load_all()

#---- Load data sets -----------------------------------------------------------

year <- .year |> as.character()

data_sets <- list_data_sets(year)

#---- Functions ----------------------------------------------------------------

list_catalogues <- function(path) {

  catalogues <- tibble(
    catalogue = here::here(
      path,
      "catalogos"
    ) |> list.files(full.names = F, recursive = FALSE),
  )
  return(catalogues)

}


#---- Get value labels ---------------------------------------------------------

enigh_catalogues <- data_sets |>
  dplyr::mutate(
    catalogues = purrr::map(path, list_catalogues)
  ) |>
  unnest(catalogues) |>
  mutate(
    catalogue_path = here(path, "catalogos", catalogue),
    value_labels = map(catalogue_path, read_inegi_csv),
    value_labels = map(value_labels, ~dplyr::rename(.x, value = 1)),
    catalogue = str_remove(catalogue, "\\.csv$")
  ) |>
  select(data_set, catalogue, value_labels) |>
  nest(value_labs = c(catalogue, value_labels))


#---- Save ---------------------------------------------------------------------

save(
  enigh_catalogues,
  file = here::here(
    "data-raw",
    "enigh",
    "data",
    "99_meta",
    year,
    "enigh_catalogues.RData"
  )
)

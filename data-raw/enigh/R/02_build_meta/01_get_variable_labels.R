#### tidyenigh #################################################################
#'
#' @name 03_get_var_labs.R
#'
#' @description
#'  Get variable labels for ENIGH data sets and saves them at each data set dir.
#'  Run through 00_run.R.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-10
#'
#### Get variable labels #######################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools)

load_all()

#---- Load data sets -----------------------------------------------------------

year <- .year |> as.character()

data_sets <- list_data_sets(year)

#---- Get variable labels ------------------------------------------------------

enigh_var_labels <- data_sets |>
  mutate(
    var_labs = map(data_set, get_enigh_var_labels)
  ) |>
  select(data_set, var_labs)


#---- Save ---------------------------------------------------------------------

save(
  enigh_var_labels,
  file = here::here(
    "data-raw",
    "enigh",
    "data",
    "99_meta",
    year,
    "enigh_var_labels.RData"
  )
)

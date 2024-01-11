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

pacman::p_load(here, tidyverse, tidyinegi)

#---- Load data sets -----------------------------------------------------------

year <- .year |> as.character()

data_sets <- tibble(
  path = here::here(
    "data-raw",
    "enigh",
    "01_raw",
    "02_unzip",
    year
  ) |> list.dirs(full.names = TRUE, recursive = F),
  data_set = str_extract(path, "[^/]+$")

)

#---- Get variable labels ------------------------------------------------------

data_set_labels <- data_sets |>
  mutate(
    labels = map(data_set, get_enigh_var_labels)
  )

#---- Save ---------------------------------------------------------------------


data_set_labels |>
  select(path, labels) |>
  pmap(
    ~ write_csv(.y, here::here(.x, "var_labels.csv")
  ))

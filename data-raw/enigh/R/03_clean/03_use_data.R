#### tidyinegi #################################################################
#'
#' @name 03_use_data.R
#'
#' @description
#' Make clean data available using `use_this::use_data()`. Run through 00_run.R
#'
#' @param .year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-15
#'
#### Use data ##################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools)

load_all()

#---- Load metadata ------------------------------------------------------------

year <- .year |> as.character()

load(here::here(
  "data-raw",
  "enigh",
  "data",
  "99_meta",
  year,
  "enigh_metadata.RData"
))

#---- Use data -----------------------------------------------------------------

for (data_set in enigh_metadata$data_set) {
  data_set_i <- data_set

  load_pre_clean_data(data_set_i)

  data_i <- get(data_set_i)

  name_i <- str_c(data_set_i, "_", year)

  assign(name_i, data_i)

  save(
    list = name_i,
    file = here::here("data", str_c(name_i, ".rda")),
    compress = T
  )

  rm(list = c(data_set_i, name_i))

}


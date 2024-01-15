#### tidyinegi #################################################################
#'
#' @name 02_check_data_sets.R
#'
#' @description
#' Check that value labels are correct for all the ENIGH data sets at a given
#' `year`. Run through 00_run.R.
#'
#' @param .year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-14
#'
#### Check data sets ###########################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools, labelled)

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

#---- Functions ----------------------------------------------------------------


read_data_set <- function(data_set, ...) {

  path <- here::here("data-raw",
                     "enigh",
                     "data",
                     "02_open",
                     year,
                     data_set,
                     "conjunto_de_datos")

  file <- list.files(path, full.names = T)

  read_inegi_csv(file, ...)

}

#---- Check labels -------------------------------------------------------------


enigh_metadata <- enigh_metadata |>
  mutate(problems = NA)


for (data_set in enigh_metadata$data_set) {
  data_set_i <- data_set

  load_pre_clean_data(data_set_i)

  # Call the loaded object programatically, according to data_set_i
  data_i <- get(data_set_i)

  # Check that the value labels are correct
  problems_i <- problem_vars(data_i)

  # Add the number of problems to the metadata
  enigh_metadata <- enigh_metadata |>
    mutate(problems = case_when(data_set == data_set_i ~ problems_i,
                                T ~ problems))

  # Remove the data set from the environment
  rm(list = data_set_i)



}

#---- Review problems ----------------------------------------------------------

problems <- enigh_metadata |>
  filter(problems > 0) |>
  mutate(original_empty = NA)


for (data_set in problems$data_set) {

  data_set_i <- data_set


  raw <- read_data_set(data_set_i)

  load_pre_clean_data(data_set_i)

  # Call the loaded object programatically, according to data_set_i
  pre_clean <- get(data_set_i)

  problems_i <- pre_clean |>
    select(where(has_problems)) |>
    names()

  original_empty_cols <- raw |>
    select(all_of(problems_i)) |>
    select(where(has_problems)) |>
    ncol()

  problems <- problems |>
    mutate(original_empty = case_when(
      data_set == data_set_i ~ original_empty_cols,
      T ~ original_empty
    ))

  rm(list = data_set_i)

}

stopifnot(sum(problems$problems) == sum(problems$original_empty))

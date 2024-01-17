#' Load pre clean data from ENIGH
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param data_set The name of a data set in ENIGH.
#' @param year ENIGH year. Defaults to global `.year`
#'
#' @return A tibble loaded into `.GlobalEnv`.
#' @export
load_pre_clean_data <- function(data_set, year) {


  path <- here::here("data-raw",
                     "enigh",
                     "data",
                     "03_pre_clean",
                     year,
                     stringr::str_c(data_set, ".RData"))

  load(path, envir = .GlobalEnv)

}

#' Detect cleaning problems in a vector
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param vector Vector to analyse
#'
#' @return `TRUE` if the vector has no valid values.
#' @export
has_problems <- function(vector) {

  vec_length <- length(vector)

  nas <- is.na(vector) |> sum()

  return(nas == vec_length)

}


#' Number of problematic variables in data
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param data A tibble to search for cleaning errors.
#'
#' @return Number of columns with cleaning errors
#' @export
problem_vars <- function(data) {

  data |>
    dplyr::select(tidyselect::where(has_problems)) |>
    ncol()

}

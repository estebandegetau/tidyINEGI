#### tidyinegi #################################################################
#'
#' @name 04_set_labels.R
#'
#' @description
#' Set variable and factor labels for all the ENIGH data sets at a given `year`.
#' Run through 00_run.R.
#'
#' @param .year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-10
#'
#### Set labels ################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, tidyinegi, labelled)

#---- Functions ----------------------------------------------------------------


set_enigh_var_labels <- function(data, data_name, year) {

  labels <- read_csv(
    here::here(
      "data-raw",
      "enigh",
      "01_raw",
      "02_unzip",
      year,
      data_name,
      "var_labels.csv"
    ),
    col_types = cols(.default = "c")
  )

  varLabels <- setNames(as.list(labels$label), labels$var)

  with_varlabs <- data |>
    set_variable_labels(.labels = varLabels)

  return(with_varlabs)

}

read_level <- function(path) {
  readr::read_csv(path,
                  col_types = readr::cols(.default = "c"),
                  locale = readr::locale(encoding = "latin1")
  ) |>
    tibble::as_tibble()
}


set_enigh_factor_labels <- function(data, data_name, year) {

  factor_vars <- tibble::tibble(
    var_path = list.files(
      here::here(
        "data-raw",
        "enigh",
        "01_raw",
        "02_unzip",
        year,
        data_name,
        "catalogos"
      ),
      full.names = T
    )
  ) |>
    dplyr::mutate(
      var = stringr::str_extract(var_path, "(?<=/)[^/]+(?=\\.csv$)"))


  factor_levels <- factor_vars |>
    dplyr::mutate(
      levels = purrr::map(var_path, read_level),
      levels = purrr::map(levels, ~dplyr::rename(.x, level = 1))
    ) |>
    dplyr::select(-var_path) |>
    tidyr::unnest(levels)


  # Recode as factors
  with_levels <- raw |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::any_of(factor_vars$var),
        ~ factor(.x,
                 labels = factor_levels |>
                   dplyr::filter(var == dplyr::cur_column()) |>
                   dplyr::pull(descripcion),
                 levels = factor_levels |>
                   dplyr::filter(var == dplyr::cur_column()) |>
                   dplyr::pull(level)
        )
      ))

  return(with_levels)
}


is_dichotomic <- function(vector) {

  vec_length <- vector |>
    # Remove NA's
    na.omit() |>
    unique() |>
    length()

  return(vec_length == 2)

}

handle_dichotomic <- function(data) {

  data |>
    dplyr::mutate(
      dplyr::across(
        .cols = tidyselect::where(is_dichotomic) & !tidyselect::matches("sexo|_hog|folio|numren"),
        ~ factor(.x, labels = c("Sí", "No"), levels = c(1, 2))
      )
    )

   }

is_numeric <- function(vector) {

  if(class(vector) == "factor") return(FALSE)

  max_vec <- vector |>
    na.omit() |>
    as.numeric() |>
    max()

  if(is.na(max_vec)) return(FALSE)

  vec_length <- vector |>
    # Remove NA's
    na.omit() |>
    unique() |>
    length()

  return(max_vec > 10 & vec_length > 4)

}

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

#---- Set labels ---------------------------------------------------------------

data_set <- "poblacion"

raw <- read_enigh_raw(data_set, year)

labelled <- raw |>
  set_enigh_factor_labels(data_set, year) |>
  handle_dichotomic() |>
  set_enigh_var_labels(data_set, year)


raw |>
  set_enigh_factor_labels(data_set)


# for (data_set in data_sets$data_set) {
#
#   raw <- read_data_set(data_sets$path[data_sets$data_set == data_set])
#
#   raw |> set_enigh_labels(data_set) |> write_csv(here::here("data", data_set))
#
# }



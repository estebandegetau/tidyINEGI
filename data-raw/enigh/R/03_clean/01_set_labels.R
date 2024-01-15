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


set_value_labels <- function(data, data_set) {

  ds_i <- data_set

  labels <- enigh_metadata |>
    select(data_set, value_labs) |>
    filter(data_set == ds_i) |>
    unnest(value_labs) |>
    select(!data_set) |>
    unnest(value_labels)


  # Recode as factors
  with_levels <- raw |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::any_of(labels$catalogue),
        ~ factor(.x,
                 labels = labels |>
                   dplyr::filter(catalogue == dplyr::cur_column()) |>
                   dplyr::pull(descripcion),
                 levels = labels |>
                   dplyr::filter(catalogue == dplyr::cur_column()) |>
                   dplyr::pull(value)
        )
      ))

  return(with_levels)
}

set_enigh_var_labels <- function(data, data_set) {

  ds_i <- data_set

  labels <- enigh_metadata |>
    select(data_set, var_labs) |>
    filter(data_set == ds_i) |>
    unnest(var_labs) |>
    select(!data_set)

  varLabels <- setNames(as.list(labels$label), labels$var)

  with_varlabs <- data |>
    set_variable_labels(.labels = varLabels)

  return(with_varlabs)

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


is_single_value <- function(vector) {

  if(class(vector) == "factor") return(FALSE)

  uniq_vals <- vector |>
    na.omit() |>
    unique() |>
    length()

  return(uniq_vals == 1)

}



handle_single_values <- function(data) {

  data |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is_single_value),
        ~ dplyr::case_when(
          !is.na(.x) ~ T
        )
      )
    )

}

is_numeric <- function(vector) {

  if(class(vector) == "factor") {return(FALSE)}


  as_numeric <- vector |>
    na.omit() |>
    as.numeric()

  if(any(is.na(as_numeric))) {return(FALSE)}

  max_vec <- vector |>
    na.omit() |>
    as.numeric() |>
    max()

  vec_length <- vector |>
    # Remove NA's
    na.omit() |>
    unique() |>
    length()

  return(max_vec > 10 & vec_length > 4)

}

is_numeric_quiet <- quietly(is_numeric)

handle_numeric <- function(data) {
  data |>
    dplyr::mutate(dplyr::across(
      tidyselect::where( ~ is_numeric_quiet(.x) |> pluck("result")) &
        !tidyselect::matches("folio|numren|_hog|_id"),
      as.numeric
    ))

}


#---- Set labels ---------------------------------------------------------------


for (data_set in data_sets$data_set) {

  raw <- read_data_set(data_set)

  pre_clean <- raw |>
    set_value_labels(data_set) |>
    handle_dichotomic() |>
    handle_single_values() |>
    handle_numeric() |>
    set_enigh_var_labels(data_set)

  assign(data_set, pre_clean)

  # Save as assigned name .RData
  save(
    list = data_set,
    file = here::here(
      "data-raw",
      "enigh",
      "data",
      "03_pre_clean",
      year,
      paste0(data_set, ".RData")
    )
  )

  # Remove from environment
  rm(list = data_set)
  gc()

}



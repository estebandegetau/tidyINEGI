#' List ENIGH data sets within a year
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param year The year of the data sets.
#' @export
#'
#' @return A tibble with the path and name of each data set.
list_data_sets <- function(year) {


  search_path <- list.dirs(
    here::here("data-raw",
               "enigh",
               "data",
               "02_open",
               year),
    full.names = TRUE,
    recursive = F
  )

    data_sets <- tibble::tibble(search_path) |>
      dplyr::mutate(
        data_set = stringr::str_extract(search_path, "[^/]+$"))

  return(data_sets)

}

#' Read an ENIGH csv file
#'
#' @description
#' Helper function to clean ENIGH data. Guesses encoding of the `.csv` file
#' before reading.
#'
#' @param path The path to the csv file.
#' @param delim Passed to [readr::read_delim()].
#' @param ... Additional arguments passed to [readr::read_delim()].
#'
#' @export
#'
#' @return A tibble.
read_inegi_csv <- function(path, delim = ",", ...) {

  encoding <- readr::guess_encoding(path) |>
    dplyr::pull(encoding) |>
    dplyr::first()

  readr::read_delim(path,
                  col_types = readr::cols(.default = "c"),
                  locale = readr::locale(encoding = encoding),
                  delim = delim,
                  ...
  ) |>
    tibble::as_tibble()
}

#' Clean file names of ENIGH data sets
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param vector A vector of file names.
#' @export
#'
#' @return A vector of clean file names.
clean_dataset_names <- function(vector) {
  a <- vector  |>
    stringr::str_remove("conjunto_de_datos_") |>
    stringr::str_remove("_ns") |>
    stringr::str_remove_all("\\d") |>
    stringr::str_remove("_enigh") |>
    stringr::str_remove("\\\t$") |>
    stringr::str_remove("_$")

  b <- dplyr::case_when(str_detect(a, "indice") ~ "indice.csv",
                      T ~ a)

  return(b)
}

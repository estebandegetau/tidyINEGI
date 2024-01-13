#' List ENIGH data sets within a year
#'
#' @param year The year of the data sets.
#'
#' @return A tibble with the path and name of each data set.
list_data_sets <- function(year) {
  data_sets <- tibble::tibble(
    path = here::here("data-raw",
                      "enigh",
                      "data",
                      "02_open",
                      year) |> list.dirs(full.names = TRUE, recursive = F)
  ) |>
    dplyr::mutate(data_set = stringr::str_extract(path, "[^/]+$"))

  return(data_sets)

}

#' Read an ENIGH csv file
#'
#' @param path The path to the csv file.
#' @param ... Additional arguments passed to `read_csv()`.
#'
#' @return A tibble.
read_inegi_csv <- function(path, ...) {
  readr::read_csv(path,
                  col_types = readr::cols(.default = "c"),
                  locale = readr::locale(encoding = "latin1"),
                  ...
  ) |>
    tibble::as_tibble()
}

#' Clean file names of ENIGH data sets
#'
#' @param vector A vector of file names.
#'
#' @return A vector of clean file names.
clean_dataset_names <- function(vector) {
  a <- vector  |>
    stringr::str_remove("conjunto_de_datos_") |>
    stringr::str_remove("_ns") |>
    stringr::str_remove_all("\\d") |>
    stringr::str_remove("_enigh") |>
    stringr::str_remove("_$")

  b <- dplyr::case_when(str_detect(a, "indice") ~ "indice.csv",
                      T ~ a)

  return(b)
}

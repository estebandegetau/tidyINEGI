#' Get variable labels for ENIGH data sets
#'
#' @param data_set Name of the data set to get the labels from. The name must
#'  match the name of the data set in the [INEGI website](https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/).
#'
#' @return A tibble with the variable names and labels
#' @export
#'
#' @examples
#' get_enigh_var_labels("viviendas")
#' get_enigh_var_labels("hogares")
get_enigh_var_labels <- function(data_set) {


  url <- "https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/"

  page <- rvest::read_html(url)

  data_set_urls <- page |>
    rvest::html_elements(".nada-list-group-item a") |>
    rvest::html_attr("href")

  data_set_url <- data_set_urls[stringr::str_extract(data_set_urls, "(\\w+)$") == data_set]

  page <- rvest::read_html(data_set_url)

  a <- page |>
    rvest::html_element("#variables-container") |>
    rvest::html_elements(".var-id") |>
    rvest::html_text2()

  # Variables are stored in every odd element in `a`
  vars <- a |>
    seq_along() |>
    purrr::keep( ~ . %% 2 == 1) |>
    purrr::map_chr( ~ a[.x])

  labs <- a |>
    seq_along() |>
    purrr::keep( ~ . %% 2 == 0) |>
    purrr::map_chr( ~ a[.x])

  labels <- tibble::tibble(var = vars,
                           label = labs) |>
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(),
        ~ stringr::str_remove_all(.x, "\\r") |>
          stringr::str_squish()
      )
    )

  return(labels)
}


#' Read raw ENIGH data sets
#'
#' @param year ENIGH year. Defaults to the value of the global.
#' @param data_set Name of the data set to read. The name must match the name of
#'       the data set in the [INEGI website](https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/).
#'
#' @return A tibble with the raw data set
#' @export
#'
#' @examples
#' year <- "2022"
#' data_set <- "poblacion"
#' read_enigh_raw(data_set, year)
# read_enigh_raw <- function(data_set, year) {
#   path <- here::here("data-raw",
#                      "enigh",
#                      "data",
#                      "02_open",
#                      year,
#                      data_set,
#                      "conjunto_de_datos")
#
#   file <- list.files(path, full.names = TRUE)
#
#   if(length(file) > 1) {
#
#     file <- file[which(stringr::str_detect("conjunto_"))]
#
#   }
#
#   raw <- readr::read_csv(file, col_types = readr::cols(.default = "c"))
#
#   return(raw)
#
# }




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
read_enigh_raw <- function(data_set, year) {
  path <- here::here("data-raw",
                     "enigh",
                     "01_raw",
                     "02_unzip",
                     year,
                     data_set,
                     "conjunto_de_datos")

  file <- list.files(path, full.names = TRUE)

  raw <- readr::read_csv(file, col_types = readr::cols(.default = "c"))

  return(raw)

}

read_level <- function(path) {
  readr::read_csv(path,
                  col_types = readr::cols(.default = "c"),
                  locale = readr::locale(encoding = "latin1")
  ) |>
    tibble::as_tibble()
}


#' #' Set ENIGH factor labels
#' #'
#' #' @param data Data frame to set the labels to
#' #' @param data_name Name of the data set. Must match the name of the data set in
#' #'        the [INEGI website](https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/).
#' #' @param year Year of the data set. Defaults to the value of the global.
#' #'
#' #' @return A data frame with the factor labels set
#' #'
#' #' @examples
#' #' year <- "2022"
#' #' data_set <- "poblacion"
#' #' raw <- read_enigh_raw(year, data_set)
#' #' labelled <- set_enigh_factor_labels(raw, data_set)
#' set_enigh_factor_labels <- function(data, data_name, year = year) {
#'
#'   factor_vars <- tibble::tibble(
#'     var_path = list.files(
#'       here::here(
#'         "data-raw",
#'         "enigh",
#'         "01_raw",
#'         "02_unzip",
#'         year,
#'         data_name,
#'         "catalogos"
#'       ),
#'       full.names = T
#'     )
#'   ) |>
#'     dplyr::mutate(
#'       var = stringr::str_extract(var_path, "(?<=/)[^/]+(?=\\.csv$)"))
#'
#'
#'   factor_levels <- factor_vars |>
#'     dplyr::mutate(
#'       levels = purrr::map(var_path, read_level),
#'       levels = purrr::map(levels, ~dplyr::rename(.x, level = 1))
#'     ) |>
#'     dplyr::select(-var_path) |>
#'     tidyr::unnest(levels)
#'
#'
#'   # Recode as factors
#'   with_levels <- raw |>
#'     dplyr::mutate(
#'       dplyr::across(
#'         tidyselect::any_of(factor_vars$var),
#'         ~ factor(.x,
#'                  labels = factor_levels |>
#'                    dplyr::filter(var == dplyr::cur_column()) |>
#'                    dplyr::pull(descripcion),
#'                  levels = factor_levels |>
#'                    dplyr::filter(var == dplyr::cur_column()) |>
#'                    dplyr::pull(level)
#'         )
#'       ))
#'
#'   return(with_levels)
#' }

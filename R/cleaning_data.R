#' Is an ENIGH variable single valued?
#'
#' @param x A vector
#'
#' @return TRUE if `x` holds only one value, other than `NA`.
is_single_value <- function(x) {

  if(is(x, "factor") | is(x, "numeric")) return(FALSE)

  uniq_vals <- x |>
    na.omit() |>
    unique() |>
    length()

  return(uniq_vals == 1)

}



#' Turn ENIGH single valued variables into logical
#'
#' @inheritParams handle_dichotomic
#'
#' @return An ENIGH data set with logical variables
#' @export
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

#' Is an ENIGH variable dichotomic?
#'
#' @param x A vector
#'
#' @export
#'
#' @return TRUE if `x` is dichotomic
#'
#' @examples
#' is_dichotomic(c("0", "1", "2"))
#' is_dichotomic(c("1", "2", "3"))
#' is_dichotomic(c("1", "2"))
is_dichotomic <- function(x) {
  if (is(x, "factor") | is(x, "logical") | is(x, "numeric")) {
    return(FALSE)
  }

  vec_uniq <- x |>
    # Remove NA's
    na.omit() |>
    unique() |>
    sort()

  if (length(vec_uniq) > 3) {
    return(FALSE)
  }

  if(length(vec_uniq) == 2) {
    if(all(vec_uniq == c("0", "1")) | all(vec_uniq == c("1", "2"))) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  } else {
  return(all(vec_uniq == c("0", "1", "2"))) }

}

#' Adds factor labels to logical vectors in ENIGH data sets
#'
#' @param data An ENIGH data set in tibble format.
#'
#' @return A tibble with labelled logical variables.
#' @export
handle_dichotomic <- function(data) {
  data |>
    dplyr::mutate(dplyr::across(
      .cols = tidyselect::where(is_dichotomic) &
        !tidyselect::matches("sexo|_hog|folio|numren"),
      ~ factor(
        .x,
        labels = c("No aplica", "S\\u00ed", "No"),
        levels = c(0, 1, 2)
      )
    ))

}




#' Is an ENIGH variable numeric
#'
#' @inheritParams is_dichotomic
#'
#' @return TRUE if `x` is numeric
is_numeric <- function(x) {

  if(is(x, "factor")) {return(FALSE)}


  as_numeric <- x |>
    na.omit() |>
    as.numeric()

  if(any(is.na(as_numeric))) {return(FALSE)}

  max_vec <- x |>
    na.omit() |>
    as.numeric() |>
    max()

  vec_length <- x |>
    # Remove NA's
    na.omit() |>
    unique() |>
    length()


  no_nas <- x |>
    as.numeric() |>
    is.na() |>
    sum() == 0

  return(max_vec > 10 | vec_length > 4 | no_nas )

}

is_numeric_quiet <- purrr::quietly(is_numeric)

is_types <- function(x) {

  matches_expr <- x |>
    stringr::str_detect("[:upper:] \\(") |>
    sum(na.rm = T)

  return(matches_expr == length(x))

}

#' Turn ENIGH numeric variables into numeric class
#'
#' @param data An ENIGH data set
#' @param data_set The name of the ENIGH data set
#' @param year Year of ENIGH survey
#'
#' @return An ENIGH data set with numeric classes
#' @export
handle_numeric <- function(data, data_set, year) {

  # Column types
  types <- readr::read_csv(
    list.files(
      here::here(
        "data-raw",
        "enigh",
        "data",
        "02_open",
        year,
        data_set,
        "diccionario_de_datos"
      ),
      full.names = T
    ),
    skip = 0,
    col_types = "c",
    col_names = F
  ) |>

    dplyr::filter(stringr::str_detect(1, "^\\d+$")) |>
    tidyr::drop_na(X2) |>
    dplyr::select(tidyselect::where(is_types)) |>
    dplyr::pull(1) |>
    stats::na.omit() |>
    stringr::str_extract("[:upper:]") |>
    stringr::str_to_lower()

  types <- dplyr::case_when(
    types %in% c("c", "n") ~ types
  ) |>
    stats::na.omit()


  numeric_vars <- tibble::tibble(variable = names(data),
                                 type = types) |>
    dplyr::filter(type == "n") |>
    dplyr::pull(numeric_vars)

  data |>
    dplyr::mutate(dplyr::across(tidyselect::any_of(numeric_vars) &
        !tidyselect::matches("folio|numren|_hog|_id"),
      as.numeric
    ))

}

#' Does a vector contain alphabetic characters?
#'
#' @param x A character vector
#'
#' @return TRUE if `x` contains alphabetic characters
#' @export
#'
#' @examples
#' has_characters(c("1", "2", "3"))
#' has_characters(c("1", "2", "3", "a"))
has_characters <- function(x) {
  x |>
    na.omit() |>
    as.character() |>
    stringr::str_detect(pattern = "[a-zA-Z]") |>
    any()
}

#' Make factor variables in ENIGH data sets compatible with official
#' documentation.
#'
#' @details Raw ENIGH data has anomallies in factor variables, such as
#' factor values that do not exactly match the official documentation.
#'
#' @param x A vector
#'
#' @return A vector with factor values compatible with official documentation.
#' @export
#'
#' @examples
#' handle_factor_values(c("1", "2", "3"))
#' handle_factor_values(c("1", "2", "3", "a"))
#' handle_factor_values(c("01", "02", "03"))
handle_factor_values <- function(x) {



  if(has_characters(x)) {return(x)}

  x |> as.numeric() |> as.character()


}



#' Compute number of NA's in every variable of an ENIGH data set
#'
#' @param data An ENIGH data set in tibble format.
#' @param ... Additional arguments passed to [tidyr::pivot_longer()]
#'
#' @return A long tibble with the number of NA's in every variable.
#' @export
nas <- function(data, ...) {
  data |>
    dplyr::summarise(dplyr::across(tidyselect::everything(),
                                   ~ sum(is.na(.x)))) |>
    tidyr::pivot_longer(tidyselect::everything(), ...)

}





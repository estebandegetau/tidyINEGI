#' Is an ENIGH variable single valued?
#'
#' @param x A vector
#'
#' @return TRUE if `x` holds only one value, other than `NA`.
is_single_value <- function(x) {

  if(is(x, "factor") | is(x, "numeric")) {return(FALSE)}

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
        labels = c("No aplica", "S\\u00ed", "No") |>
          stringi::stri_unescape_unicode(),
        levels = c(0, 1, 2)
      )
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





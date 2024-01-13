#' INEGI Data Menu
#' @description
#' Display a list of [INEGI](https://www.inegi.org.mx/) data projects supported
#'  by `tidyinegi`. If you wish to load the menu visibly into memory,
#'  use `data(data_menu)`.
#' @param .quiet Use to avoid printing list.
#'
#' @return a `tibble`.
#' @export
#'
#' @examples
#'   inegi_menu()
inegi_menu <- function(.quiet = FALSE) {

  invisible(data_menu)

  if(!.quiet) {knitr::kable(data_menu, format = "rst")} #else{return(data_menu)}

}

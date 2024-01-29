#' Create ENIGH package data
#'
#' Makes it easy to ship data in a package, replicating what
#' [usethis::use_data()] does, but for ENIGH data.
#'
#' @param data_set The name of an ENIGH data set
#' @param year The year of the ENIGH survey
#'
#' @export
use_enigh <- function(data, data_set, year) {

  final_name <- stringr::str_c(data_set, year)

  assign(final_name, data)

  # Save as assigned name .RData
  save(
    version = 3,
    list = final_name,
    file = here::here("data", str_c(final_name, ".RData")),
    compress = "xz"
  )

  # Remove from environment
  rm(list = final_name)


}

#' Download and unzip data from INEGI
#'
#' @description
#' Helper function to clean ENIGH data.
#'
#' @param url A character string with the URL of the data to download. Must end in `.zip`
#' @param output_dir A character string with the path to the directory where the data will be saved.
#' @export
#'
#' @return A character string with the path to the directory where the data was saved.
raw_inegi_data <- function(url, output_dir = "data") {


  withr::with_options(list(timeout = max(300, getOption("timeout"))), {
    temp <- tempfile()
    download.file(url, temp, cacheOK = FALSE, method = "libcurl")
    unzip(temp, exdir = output_dir)
    unlink(temp)
  })

  return(cat("Data saved to:", here::here(output_dir)))
}


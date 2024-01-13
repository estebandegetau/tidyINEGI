#### tidyinegi #################################################################
#'
#' @name 01_unzip.R
#'
#' @description
#' Unzip an ENIGH zip file. Run through 00_run.R
#'
#' @describeIn `year`.zip An ENIGH zip file from year `year`.
#'
#' @param year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-09
#'
#### Unzip #####################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here)

#---- Unzip --------------------------------------------------------------------

year <- .year |> as.character()

file <- paste0(year, ".zip")

path <- here::here("data-raw", "enigh", "data", "01_zip",  file)

unzip(
  path,
  exdir = here::here("data-raw", "enigh", "data", "02_open", year)
  )

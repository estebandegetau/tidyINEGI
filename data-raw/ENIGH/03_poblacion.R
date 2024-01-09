#### tidyinegi #################################################################
#'
#' @name 03_poblacion.R
#'
#' @description
#' Transform the population data from the ENIGH into a tidy data set. Run
#' through 00_run.R
#'
#' @describeIn `year` A year.
#'
#' @param year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-09
#'
#### Poblacion #################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, rvest, labelled)

#---- Poblacion ----------------------------------------------------------------

year <- .year |> as.character()

#---- Load ---------------------------------------------------------------------

# dir <- here::here(
#   "data-raw",
#   "enigh",
#   "01_raw",
#   "02_unzip",
#   year,
#   "poblacion",
#   "conjunto_de_datos"
#   )
#
# file <- list.files(dir, full.names = TRUE)
#
# raw <- read_csv(file, col_types = cols(.default = "c"))


#---- Labels -------------------------------------------------------------------

page <- rvest::read_html("https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/F72?file_name=poblacion")



a <- page |>
  html_element("#variables-container") |>
  html_table()

a

a


a |>
#  html_element("div") |>
  html_table()

a

# Adjust the CSS selector as needed to target the specific table
table <- page |>
 # html_elements("#variables-container") |>
  html_table()





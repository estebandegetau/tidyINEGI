#### tidyinegi #################################################################
#'
#' @name 02_rename_dirs.R
#'
#' @description
#' Rename the directories of the unzipped ENIGH files. Run through 00_run.R
#'
#' @describeIn `year` A year.
#'
#' @param year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-09
#'
#### Rename directories ########################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse)

#---- Rename directories -------------------------------------------------------

year <- .year |> as.character()

path <- here::here(
  "data-raw",
  "enigh",
  "01_raw",
  "02_unzip",
  year
  )

dirs <- tibble(
  raw = list.files(path, full.names = F)
) |>
  mutate(
    clean = str_remove(raw, "conjunto_de_datos_") |>
      str_remove("_ns") |>
      str_remove_all("\\d") |>
      str_remove("_enigh") |>
      str_remove("_$"),
    clean = case_when(
      str_detect(clean, "indice") ~ "indice.csv",
      T ~ clean
      )
    )

# Rename directories
dirs |>
  mutate(
    old = raw,
    new = clean
    ) |>
  pwalk(
    ~ file.rename(
      from = here::here("data-raw", "enigh", "01_raw", "02_unzip", year, ..1),
      to = here::here("data-raw", "enigh", "01_raw", "02_unzip", year, ..2)
      )
    )




#### tidyinegi #################################################################
#'
#' @name 00_run.R
#'
#' @description
#' Run all scripts in the data-raw folder to transform raw ENIGH data from
#' INEGI into analysis-ready data sets.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-09
#'
#### Run #######################################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here)

#---- Setup --------------------------------------------------------------------

.year <- 2020

._01_unzip       <- 1
._02_rename_dirs <- 1

#---- Run ----------------------------------------------------------------------

if (._01_unzip) {
  source(here::here("data-raw", "enigh", "01_unzip.R"), encoding = "UTF-8")
}

if (._02_rename_dirs) {
  source(here::here("data-raw", "enigh", "02_rename_dirs.R"), encoding = "UTF-8")
}


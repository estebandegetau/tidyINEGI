#### tidyinegi #################################################################
#'
#' @name 02_check_data_sets.R
#'
#' @description
#' Check that value labels are correct for all the ENIGH data sets at a given
#' `year`. Run through 00_run.R.
#'
#' @param .year A year.
#'
#' @author Esteban Degetau
#'
#' @created 2024-01-14
#'
#### Check data sets ###########################################################

rm(list = ls())
gc()

#---- Libraries ----------------------------------------------------------------

pacman::p_load(here, tidyverse, devtools, labelled)

load_all()

#---- Load metadata ------------------------------------------------------------



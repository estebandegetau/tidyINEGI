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

pacman::p_load(here, tidyverse, labelled, tidyinegi)

#---- Poblacion ----------------------------------------------------------------

year <- .year |> as.character()

#---- Load ---------------------------------------------------------------------

dir <- here::here(
  "data-raw",
  "enigh",
  "01_raw",
  "02_unzip",
  year,
  "poblacion",
  "conjunto_de_datos"
  )

file <- list.files(dir, full.names = TRUE)

raw <- read_csv(file, col_types = cols(.default = "c"))


#---- Variable labels ----------------------------------------------------------



labels <- get_enigh_var_labels(
  url = "https://www.inegi.org.mx/rnm/index.php/catalog/901/data-dictionary/F72?file_name=poblacion"
)

varLabels <- setNames(as.list(labels$label), labels$var)

with_varlabs <- raw |>
  set_variable_labels(.labels = varLabels)

#---- Factor levels ------------------------------------------------------------

read_level <- function(path) {
  read_csv(path,
    col_types = cols(.default = "c"),
    locale = locale(encoding = "latin1")
  ) |>
    as_tibble()
}

factor_vars <- tibble(
  var_path = list.files(
  here::here(
    "data-raw",
    "enigh",
    "01_raw",
    "02_unzip",
    year,
    "poblacion",
    "catalogos"
  ),
  full.names = T
)
) |>
  mutate(
    var = str_extract(var_path, "(?<=/)[^/]+(?=\\.csv$)"))


factor_levels <- factor_vars |>
mutate(
  levels = map(var_path, read_level),
  levels = map(levels, ~rename(.x, level = 1))
  ) |>
  select(-var_path) |>
  unnest(levels)


# Recode as factors
with_levels <- raw |>
  mutate(
    across(
      any_of(factor_vars$var),
      ~ factor(.x, labels = factor_levels |>
                filter(var == cur_column()) |>
                pull(descripcion),
              levels = factor_levels |>
                filter(var == cur_column()) |>
                pull(level)
    )
  ))

with_levels |> slice_head(n = 100) |> View()

with_levels |>
  rename(factor_exp = factor) |>
  mutate(factor_exp = as.numeric(factor_exp)) |>
  group_by(lenguaind) |>
  summarise(n = sum(factor_exp)) |>
  arrange(desc(n)) |>
  View()

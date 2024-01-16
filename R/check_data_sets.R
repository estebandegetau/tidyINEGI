load_pre_clean_data <- function(data_set) {

  path <- here::here("data-raw",
                     "enigh",
                     "data",
                     "03_pre_clean",
                     year,
                     str_c(data_set, ".RData"))

  load(path, envir = .GlobalEnv)

}

has_problems <- function(vector) {

  vec_length <- length(vector)

  nas <- is.na(vector) |> sum()

  return(nas == vec_length)

}


problem_vars <- function(data) {

  data |>
    select(where(has_problems)) |>
    ncol()

}

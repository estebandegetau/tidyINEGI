## code to prepare `data_menu` dataset goes here

rm(list = ls())
gc()

data_menu <- tibble::tibble(
  Survey = c("ENIGH"),
  Series = c("Nueva serie"),
  Year = c(as.character(seq(2016, 2022, 2)))
) |>
  group_by(Survey, Series) |>
  summarise(Year = str_c(min(Year), "-", max(Year))) |>
  ungroup()


usethis::use_data(data_menu, overwrite = TRUE)

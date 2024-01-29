test_that("scrapper works", {
  expect_equal(get_enigh_var_labels("poblacion") |> nrow(), 188)
})

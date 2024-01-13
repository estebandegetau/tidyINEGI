test_that("displeys menu", {
  expect_true({inegi_menu(.quiet = T)
               data_menu |> nrow() > 0})
  expect_true({inegi_menu(.quiet = T)
    data_menu |> ncol() == 3})
  expect_visible(inegi_menu())
  expect_invisible(inegi_menu(.quiet = T))
})

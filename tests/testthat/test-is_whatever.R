test_that("is_dichotomic works", {
  expect_equal(is_dichotomic(c("0", "1", "2")), TRUE)
  expect_equal(is_dichotomic(c("1", "2", "3")), FALSE)
  expect_equal(is_dichotomic(c("1", "2")), TRUE)
  expect_equal(is_dichotomic(c("0", "1")), TRUE)
  expect_equal(is_dichotomic(c(NA, "1", "2")), TRUE)
  expect_equal(is_dichotomic(c(NA, "1")), FALSE)
  expect_equal(is_dichotomic(c(NA)), FALSE)
  expect_equal(is_dichotomic(c(NA, "30000", "50000")), FALSE)
})

test_that("is_single_value", {
  expect_equal(is_single_value(c("0", "1", "2")), FALSE)
  expect_equal(is_single_value(c(NA, "1")), TRUE)



})

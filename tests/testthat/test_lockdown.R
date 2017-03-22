context("Lock down a file or variable")

test_that("A variable can be locked down", {
  cache_fp <- tempfile(fileext=".rds")
  a <- 5
  expect_equal(lockdown_variable(a, cache_fp), NA)
  a <- 5
  expect_equal(lockdown_variable(a, cache_fp), TRUE)
  a <- 5.1
  expect_error(lockdown_variable(a, cache_fp))
  unlink(cache_fp)
})

test_that("A file can be locked down", {
  cache_fp <- tempfile(fileext=".rds")
  test_fp <- tempfile(fileext=".txt")
  cat("abcdefg", file=test_fp)
  expect_equal(lockdown_file(test_fp, cache_fp), NA)
  cat("abcdefg", file=test_fp)
  expect_equal(lockdown_file(test_fp, cache_fp), TRUE)
  cat("abcdefgh", file=test_fp)
  expect_error(lockdown_file(test_fp, cache_fp))
  unlink(cache_fp)
})

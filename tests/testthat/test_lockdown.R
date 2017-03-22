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

context("Remove a locked-down file or variable")

test_that("A locked-down variable can be removed", {
  cache_fp <- tempfile(fileext=".rds")
  expect_equal(lockdown_remove_variable(a, cache_fp), NA)
  a <- 5
  expect_equal(lockdown_remove_variable(a, cache_fp), NA)
  lockdown_variable(a, cache_fp)
  expect_equal(lockdown_remove_variable(a, cache_fp), TRUE)
  # No error after changing variable
  a <- 6
  lockdown_variable(a, cache_fp)
  unlink(cache_fp)
})

test_that("A locked-down file can be removed", {
  cache_fp <- tempfile(fileext=".rds")
  test_fp <- tempfile(fileext=".txt")
  # File does not need to exist
  # If it's not in the cache, that's good enough
  expect_equal(lockdown_remove_file(test_fp, cache_fp), NA)
  cat("abcdefg", file=test_fp)
  # Exists but is not locked down -- return NA
  expect_equal(lockdown_remove_file(test_fp, cache_fp), NA)
  lockdown_file(test_fp, cache_fp)
  # Exists, was locked, successfully removed -- return TRUE
  expect_equal(lockdown_remove_file(test_fp, cache_fp), TRUE)
  # No error after changing the file
  cat("abcdefgh", file=test_fp)
  lockdown_file(test_fp, cache_fp)
  unlink(cache_fp)
})

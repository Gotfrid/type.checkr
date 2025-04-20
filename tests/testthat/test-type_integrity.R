test_that("01_type_integrity: fails if a param has no corresponding type", {
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("01_type_integrity.R"))
  })
  expect_false(check_result)
})

test_that("02_type_integrity: fails if typeParam references non-existing param", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("02_type_integrity.R"))
  })
  expect_false(check_result)
})

test_that("03_type_integrity: passed when param and type are in place", {
  check_result <- analyze(tfile("03_type_integrity.R"))
  expect_true(check_result)
})

test_that("09_return_type: variable is typed based on the function", {
  check_result <- analyze(tfile("09_return_type.R"))
  expect_true(check_result)
})

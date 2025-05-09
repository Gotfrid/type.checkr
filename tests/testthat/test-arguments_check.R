test_that("04_arguments_check: unnamed arguments are not supported", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("04_arguments_check.R"))
  })
  expect_false(check_result)
})

test_that("05_arguments_check: character vs integer", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("05_arguments_check.R"))
  })
  expect_false(check_result)
})

test_that("06_arguments_check: numeric vs integer", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("06_arguments_check.R"))
  })
  expect_false(check_result)
})

test_that("07_arguments_check: integer vector vs integer scalar", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(tfile("07_arguments_check.R"))
  })
  expect_false(check_result)
})

test_that("08_arguments_check: integer scalar passes", { # nolint
  expect_no_warning({
    check_result <- analyze(tfile("08_arguments_check.R"))
  })
  expect_true(check_result)
})

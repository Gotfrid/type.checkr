test_that("04_arguments_check: arguments of called functions are analyzed and compared against the type definition", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(
      system.file(
        "testcases", "04_arguments_check.R",
        package = "type.checkr"
      )
    )
  })
  expect_false(check_result)
})

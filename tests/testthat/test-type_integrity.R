test_that("01_type_integrity: fails if a param has no corresponding type", {
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(
      system.file(
        "testcases", "01_typing_integrity.R",
        package = "type.checkr"
      )
    )
  })
  expect_false(check_result)
})

test_that("02_type_integrity: fails if typeParam references non-existing param", { # nolint
  expect_warning(regexp = "TypeError", {
    check_result <- analyze(
      system.file(
        "testcases", "02_typing_integrity.R",
        package = "type.checkr"
      )
    )
  })
  expect_false(check_result)
})

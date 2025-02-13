
test_that("df output", {
  test <- here("test_inputs", "dummy_rep_test.xlsx") %>%
    read_excel() %>%
    clean_names()

  expected <- here("test_inputs", "dummy_rep_test_expected.csv") %>%
    read_csv() %>%
    mutate(seeding_date = as.POSIXct(seeding_date, format = "%m/%d/%y", tz = "UTC"),
           treatment_date = as.POSIXct(treatment_date, format = "%m/%d/%y", tz = "UTC"))
  #to find the differences: all.equal(actual, expected)
  expect_true(identical(dummy_rep(test), expected))
})

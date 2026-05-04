cvd_flag_leap <- flagleap(CVD, report = FALSE)

test_that("flagleap works", {
  expect_equal(cvd_flag_leap$ndaysmonth[2], 28) # Feb
  expect_equal(cvd_flag_leap$ndaysmonth[158], 29) # leap Feb
  expect_equal(cvd_flag_leap$month[2], 2)
  expect_equal(cvd_flag_leap$month[158], 2)
  expect_equal(cvd_flag_leap$year[2], 1987)
  expect_equal(cvd_flag_leap$year[158], 2000)

  expect_output(
    print(flagleap(CVD, report = TRUE)),
    "Total number of days =  5114"
  )
})
## Checks that flagleap can distinguish leap months from regular months (Feb),
## and correctly identify year and month.

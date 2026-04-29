# date1 <- as.Date(c(
#   "1987-01-01",
#   "1987-01-02",
#   "1987-01-03",
#   "1987-01-04",
#   "1987-01-05"
# ))
# date2 <- as.Date(c("1987-12-30", "1987-12-31", "1988-01-01", "1988-01-02"))
#
# test_that("yrfraction works", {
#   expect_equal(yrfraction(date1), c(0, 1 / 365, 2 / 365, 3 / 365, 4 / 365))
#   expect_equal(yrfraction(date2), c(363 / 365, 364 / 365, 0, 1 / 366))
#   expect_equal(
#     yrfraction(c(1, 2, 3), type = "weekly"),
#     c(0, 1 / (365.25 / 7), 2 / (365.25 / 7))
#   )
#   expect_equal(yrfraction(c(1, 2, 3), type = "monthly"), c(0, 1 / 12, 1 / 6))
# })
# ## same logic as inverse year fraction.
# ## takes readily identifiable dates and tests in yrfrac correctly maps them.

####----
date_tbl_1 <- data.frame(
  date = as.Date(
    c(
      "1987-01-01",
      "1987-01-02",
      "1987-01-03",
      "1987-01-04",
      "1987-01-05"
    ),
  ),
  yday = 0:4
)

date_tbl_1$frac <- c(date_tbl_1$yday / 365)

date_tbl_2 <- data.frame(
  date = as.Date(
    c("1987-12-30", "1987-12-31", "1988-01-01", "1988-01-02")
  ),
  yday = c(363, 364, 0, 1)
)

date_tbl_2$frac <- c(
  date_tbl_2$yday[1] / 365,
  date_tbl_2$yday[2] / 365,
  0,
  1 / 366
)

test_that("yrfraction works", {
  expect_equal(yrfraction(date_tbl_1$date), date_tbl_1$frac)
  expect_equal(yrfraction(date_tbl_2$date), date_tbl_2$frac)
  expect_equal(
    yrfraction(c(1, 2, 3), type = "weekly"),
    c(0, 1 / (365.25 / 7), 2 / (365.25 / 7))
  )
  expect_equal(
    yrfraction(c(1, 2, 3), type = "monthly"),
    c(0, 1 / 12, 2 / 12)
  )
})
## same logic as inverse year fraction.
## takes readily identifiable dates and tests in yrfrac correctly maps them.

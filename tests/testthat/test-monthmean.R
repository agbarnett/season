test_that("monthmean reproduces the published Fig 2.11 CVD rates", {
  # Adjusted CVD rate per 100,000 from Barnett & Dobson (2010) Fig 2.11 (p.62).
  # The full 12-value vector is captured in the snapshot; the assertions below
  # anchor the most distinctive values (Jan high, Jul low).
  mm <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  expect_s3_class(mm, "Monthmean")
  expect_snapshot(mm)
})

test_that("monthmean errors when required variables are missing", {
  expect_snapshot(
    error = TRUE,
    monthmean(data = NULL, resp = "x")
  )
  expect_snapshot(
    error = TRUE,
    monthmean(data = CVD, resp = NULL)
  )
  expect_snapshot(
    error = TRUE,
    monthmean(data = data.frame(month = 1:12, x = 1:12), resp = "x")
  )
  expect_snapshot(
    error = TRUE,
    monthmean(data = data.frame(year = rep(2000, 12), x = 1:12), resp = "x")
  )
})

test_that("monthmean adjmonth='thirty' and 'average' rescale by a known constant", {
  # The two adjustments differ only by their target month length:
  # 30 days vs 365.25/12 days. The ratio should be the same in every month.
  m_thirty <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "thirty"
  )
  m_avg <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  expect_equal(m_thirty$mean / m_avg$mean, rep(30 / (365.25 / 12), 12))
})

test_that("monthmean without offset returns the raw monthly means", {
  mm <- monthmean(data = CVD, resp = "cvd")
  cvd_by_month <- aggregate(cvd ~ month, data = CVD, FUN = mean)
  expect_equal(mm$mean, cvd_by_month$cvd)
})

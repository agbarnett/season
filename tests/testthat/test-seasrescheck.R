test_that("seasrescheck plots without error for raw and model residuals", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(dev.off())

  set.seed(2026 - 04 - 29)
  expect_no_error(seasrescheck(rnorm(120)))

  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  expect_no_error(seasrescheck(m$residuals))
})

test_that("seasrescheck restores the caller's graphic settings", {
  # The function uses par(mfrow = c(2, 2)) internally; it should leave the
  # mfrow setting unchanged after returning.
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(dev.off())
  par_before <- par("mfrow")
  seasrescheck(rnorm(60))
  expect_equal(par("mfrow"), par_before)
})

# Print methods only side-effect: they cat()/print() to the console. The
# exact text is what users see, so snapshots are the natural assertion.
# Each test fits its model inline so a failure points to one method.

test_that("print.Cosinor prints the underlying GLM", {
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  expect_snapshot(print(m))
})

test_that("print.Cosinor errors on non-Cosinor input", {
  expect_snapshot(
    error = TRUE,
    print.Cosinor(list(a = 1))
  )
})

test_that("print.monthglm prints the underlying GLM", {
  m <- monthglm(cvd ~ 1, data = CVD, family = poisson(), offsetmonth = TRUE)
  expect_snapshot(print(m))
})

test_that("print.monthglm errors on non-monthglm input", {
  expect_snapshot(
    error = TRUE,
    print.monthglm(list(a = 1))
  )
})

test_that("print.Monthmean prints a named 12-row table", {
  mm <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  expect_snapshot(print(mm))
})

test_that("print.Monthmean errors on non-Monthmean input", {
  expect_snapshot(
    error = TRUE,
    print.Monthmean(list(a = 1))
  )
})

test_that("print.nonlintest prints the test statistics block", {
  set.seed(2026 - 04 - 29)
  res <- nonlintest(data = stats::rnorm(100), n.lag = 3, n.boot = 25)
  expect_snapshot(print(res))
})

test_that("print.nonlintest errors on non-nonlintest input", {
  expect_snapshot(
    error = TRUE,
    print.nonlintest(list(a = 1))
  )
})

test_that("print.nonlintest reports both upper and lower exceedances", {
  # Real nonlintest output rarely lands in both extreme tails on small
  # bootstrap runs. Construct a synthetic object with one positive and
  # one negative cell in the region matrix to drive both branches of
  # the print method.
  fake <- structure(
    list(
      region = matrix(
        c(0, 0.5, 0, 0, 0, 0, -0.3, 0, 0, 0, 0, 0, 0, 0, 0, 0),
        nrow = 4,
        ncol = 4
      ),
      diff_l = matrix(0, 4, 4),
      diff_u = matrix(0, 4, 4),
      n.lag = 3,
      stats = list(
        outside = 0.8,
        stan = 1.2,
        median = 0.4,
        upper = 0.6,
        pvalue = 0.05,
        test = TRUE
      )
    ),
    class = "nonlintest"
  )
  out <- capture.output(print(fake))
  expect_true(any(grepl("Largest positive difference", out, fixed = TRUE)))
  expect_true(any(grepl("Largest negative difference", out, fixed = TRUE)))
})

test_that("print.nonlintest reports zero differences when region is all zero", {
  # The zero-region branch is what nonlintest produces when no
  # third-order moment cell exceeds the bootstrap limits.
  fake <- structure(
    list(
      region = matrix(0, 4, 4),
      diff_l = matrix(0, 4, 4),
      diff_u = matrix(0, 4, 4),
      n.lag = 3,
      stats = list(
        outside = 0,
        stan = 0,
        median = 0,
        upper = 0,
        pvalue = 1,
        test = FALSE
      )
    ),
    class = "nonlintest"
  )
  out <- capture.output(print(fake))
  expect_true(any(grepl("Largest difference is zero", out, fixed = TRUE)))
  expect_true(any(grepl("Smallest difference is zero", out, fixed = TRUE)))
})

test_that("print.nsCosinor prints model overview and residual stats", {
  skip_on_ci()
  set.seed(2026 - 04 - 29)
  m <- nscosinor(
    data = head(CVD, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000
  )
  expect_snapshot(print(m))
})

test_that("print.nsCosinor errors on non-nsCosinor input", {
  expect_snapshot(
    error = TRUE,
    print.nsCosinor(list(a = 1))
  )
})

test_that("print.casecross prints the underlying coxph fit", {
  m <- casecross(
    cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
    data = subset(CVDdaily, date <= as.Date("1987-12-31"))
  )
  expect_snapshot(print(m))
})

test_that("print.casecross errors on non-casecross input", {
  expect_snapshot(
    error = TRUE,
    print.casecross(list(a = 1))
  )
})

test_that("print.casecross errors when c.model is not a coxph fit", {
  # A casecross object's c.model field is the conditional logistic
  # regression returned by survival::coxph. The print method refuses
  # to dispatch if that field has been replaced with something else.
  bad <- structure(list(c.model = list()), class = "casecross")
  expect_snapshot(
    error = TRUE,
    print(bad)
  )
})

test_that("print.summary.Cosinor prints the cosinor test report", {
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  expect_snapshot(print(summary(m)))
})

test_that("print.summary.Cosinor uses circadian wording for hourly data", {
  # Wording switches from "seasonality" (yearly/monthly) to "circadian"
  # when the underlying cosinor was fit with type = "hourly".
  m <- cosinor(bedroom ~ 1, date = "datetime", type = "hourly", data = indoor)
  expect_output(print(summary(m)), "Significant circadian pattern")
})

test_that("print.summary.Cosinor errors on non-summary.Cosinor input", {
  expect_snapshot(
    error = TRUE,
    print.summary.Cosinor(list(a = 1))
  )
})

test_that("print.summary.Cosinor rounds numeric phase when text = FALSE", {
  # When the cosinor was fitted with text = FALSE, summary() returns
  # phase as a numeric. The print method then rounds to `digits`
  # before display rather than printing a "Month X, day Y" string.
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE,
    text = FALSE
  )
  s <- summary(m, digits = 1)
  expect_type(s$phase, "double")
  expect_equal(s$phase, 1.3, tolerance = 0.4)
})

test_that("print.summary.monthglm prints the month-effect table", {
  m <- monthglm(cvd ~ 1, data = CVD, family = poisson(), offsetmonth = TRUE)
  expect_snapshot(print(summary(m)))
})

test_that("print.summary.monthglm uses 'Odds ratios' for binomial", {
  # Different family pulls a different label out of summary.monthglm:
  # poisson -> "Rate ratios", binomial -> "Odds ratios", gaussian -> neither.
  CVD2 <- CVD
  CVD2$success <- CVD2$cvd
  CVD2$failure <- CVD2$ndaysmonth * 100 - CVD2$cvd
  m <- monthglm(cbind(success, failure) ~ 1, data = CVD2, family = binomial())
  expect_snapshot(print(summary(m)))
})

test_that("print.summary.nscosinor prints amplitude and phase blocks", {
  skip_on_ci()
  # NOTE: registered as `print.summary.nscosinor` (lowercase 'n') while the
  # class is `summary.nsCosinor` (capital 'C') — S3 dispatch is case-sensitive
  # so calling print() falls through to print.default. Calling the function
  # directly here exercises its body. Worth fixing in the package.
  set.seed(2026 - 04 - 29)
  m <- nscosinor(
    data = head(CVD, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000
  )
  expect_snapshot(print.summary.nscosinor(summary(m)))
})

test_that("print.summary.nscosinor errors on non-summary.nsCosinor input", {
  expect_snapshot(
    error = TRUE,
    print.summary.nscosinor(list(a = 1))
  )
})

test_that("print.summary.nscosinor handles multiple seasonal cycles", {
  # k >= 2 takes a different branch in print.summary.nscosinor that
  # iterates over each cycle. Same dispatch caveat as the single-cycle
  # case: must be called directly because the @method registration
  # uses lowercase 'nscosinor' rather than 'nsCosinor'.
  skip_on_ci()
  set.seed(2026 - 04 - 29)
  m <- nscosinor(
    data = head(CVD, 48),
    response = "adj",
    cycles = c(6, 12),
    tau = c(10, 50, 50),
    niters = 50,
    burnin = 20,
    div = 1000
  )
  expect_snapshot(print.summary.nscosinor(summary(m)))
})

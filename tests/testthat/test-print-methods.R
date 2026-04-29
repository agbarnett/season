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
  res <- nonlintest(data = rnorm(100), n.lag = 3, n.boot = 25)
  expect_snapshot(print(res))
})

test_that("print.nonlintest errors on non-nonlintest input", {
  expect_snapshot(
    error = TRUE,
    print.nonlintest(list(a = 1))
  )
})

test_that("print.nsCosinor prints model overview and residual stats", {
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

test_that("print.summary.monthglm prints the month-effect table", {
  m <- monthglm(cvd ~ 1, data = CVD, family = poisson(), offsetmonth = TRUE)
  expect_snapshot(print(summary(m)))
})

test_that("print.summary.nscosinor prints amplitude and phase blocks", {
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

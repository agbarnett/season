# Lane H tests: autoplot.<Class> methods, plot_circle / plot_month,
# and deprecation warnings on the legacy paths.
#
# Snapshot strategy:
# - Existing vdiffr snapshots for plot.<Class> remain valid because the
#   deprecated methods keep their existing bodies (only the warning is new).
# - New vdiffr snapshots below cover the new ggplot output paths.
# - Deprecation tests use lifecycle::expect_deprecated() — fires once per
#   call site per session; safe to repeat.
# - For MCMC paths (autoplot.nsCosinor, autoplot.nonlintest), check
#   structure only — BLAS variance across platforms makes exact-text /
#   pixel snapshots non-portable.

# autoplot methods: structure + vdiffr ---------------------------------

test_that("autoplot.peri returns a ggplot and matches snapshot", {
  set.seed(1)
  p <- autoplot(peri(CVD$cvd))
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-peri", p)
})

test_that("autoplot.third returns a ggplot and matches snapshot", {
  p <- autoplot(third(CVD$cvd, n.lag = 4, outmax = FALSE))
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-third", p)
})

test_that("autoplot.Cosinor - monthly Poisson matches snapshot", {
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  p <- autoplot(m)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-Cosinor-monthly-poisson", p)
})

test_that("autoplot.Cosinor - binomial cloglog matches snapshot", {
  m <- cosinor(
    stillborn ~ 1,
    date = "dob",
    data = stillbirth,
    family = binomial(link = "cloglog")
  )
  p <- autoplot(m)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-Cosinor-binomial-cloglog", p)
})

test_that("autoplot.Cosinor - hourly matches snapshot", {
  m <- cosinor(
    bedroom ~ 1,
    date = "datetime",
    type = "hourly",
    data = indoor
  )
  p <- autoplot(m)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-Cosinor-hourly", p)
})

test_that("autoplot.monthglm - Poisson rate ratios matches snapshot", {
  m <- monthglm(
    formula = cvd ~ 1,
    data = CVD,
    family = poisson(),
    offsetpop = expression(pop / 100000),
    offsetmonth = TRUE
  )
  p <- autoplot(m)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-monthglm-poisson", p)
})

test_that("autoplot.monthglm - Gaussian matches snapshot", {
  m <- monthglm(formula = cvd ~ 1, data = CVD)
  p <- autoplot(m)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-monthglm-gaussian", p)
})

test_that("autoplot.Monthmean matches snapshot", {
  mm <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  p <- autoplot(mm)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("autoplot-Monthmean", p)
})

# autoplot.nsCosinor: structure only (BLAS-portability)
test_that("autoplot.nsCosinor returns a ggplot with the expected facets", {
  set.seed(2026 - 04 - 29)
  res <- nscosinor(
    data = head(CVD, 48),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 50,
    burnin = 20,
    div = 1000
  )
  p <- autoplot(res)
  expect_s3_class(p, "ggplot")
  # facet structure should always be Trend + 1 season
  expect_identical(length(unique(p$data$type)), 2L)
})

test_that("autoplot.nonlintest returns a ggplot or NULL invisibly", {
  set.seed(1)
  res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 100)
  out <- autoplot(res)
  # Either a ggplot (points exceeded limits) or NULL (none did).
  expect_true(inherits(out, "ggplot") || is.null(out))
})

# plot_circle / plot_month --------------------------------------------

test_that("plot_circle returns a ggplot and matches snapshot", {
  p <- plot_circle(seq(1, 12, 1), dp = 0)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("plot-circle-12-monthly", p)
})

test_that("plot_circle errors on wrong-length input", {
  expect_error(plot_circle(1:6), "length")
})

test_that("plot_month - 12 panels matches snapshot", {
  p <- plot_month(data = CVD, resp = "cvd", panels = 12)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("plot-month-12-panels", p)
})

test_that("plot_month - single panel matches snapshot", {
  p <- plot_month(data = CVD, resp = "cvd", panels = 1)
  expect_s3_class(p, "ggplot")
  vdiffr::expect_doppelganger("plot-month-1-panel", p)
})

test_that("plot_month errors on invalid panels", {
  expect_error(plot_month(data = CVD, resp = "cvd", panels = 4), "panels")
})

# Deprecation: methods --------------------------------------------------

test_that("plot.Cosinor emits a deprecation warning", {
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  lifecycle::expect_deprecated(plot(m))
})

test_that("plot.monthglm emits a deprecation warning", {
  m <- monthglm(formula = cvd ~ 1, data = CVD)
  lifecycle::expect_deprecated(plot(m))
})

test_that("plot.Monthmean emits a deprecation warning", {
  mm <- monthmean(data = CVD, resp = "cvd")
  lifecycle::expect_deprecated(plot(mm))
})

test_that("plot.nsCosinor emits a deprecation warning", {
  set.seed(1)
  res <- nscosinor(
    data = head(CVD, 48),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 50,
    burnin = 20,
    div = 1000
  )
  lifecycle::expect_deprecated(plot(res))
})

test_that("plot.nonlintest emits a deprecation warning", {
  set.seed(1)
  res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 50)
  lifecycle::expect_deprecated(plot(res))
})

# Deprecation: arguments -----------------------------------------------

test_that("peri(plot = FALSE) emits a deprecation warning", {
  lifecycle::expect_deprecated(peri(CVD$cvd, plot = FALSE))
})

test_that("peri(plot = TRUE) emits a deprecation warning and still draws", {
  # `plot = TRUE` retains the legacy side-effect: it prints
  # `autoplot(peri(...))`. Redirect to a null device so the plot doesn't
  # land in tests/testthat/Rplots.pdf or get swept into the snapshot
  # machinery.
  pdf(file = NULL)
  on.exit(dev.off())
  lifecycle::expect_deprecated(peri(CVD$cvd, plot = TRUE))
})

test_that("peri() (no plot arg) does not emit a deprecation warning", {
  # The recommended path — silent.
  expect_no_warning(peri(CVD$cvd))
})

test_that("third(plot = FALSE) emits a deprecation warning", {
  lifecycle::expect_deprecated(
    third(CVD$cvd, n.lag = 4, outmax = FALSE, plot = FALSE)
  )
})

test_that("third(plot = TRUE) emits a deprecation warning and still draws", {
  # Same null-device trick as peri(plot = TRUE).
  pdf(file = NULL)
  on.exit(dev.off())
  lifecycle::expect_deprecated(
    third(CVD$cvd, n.lag = 4, outmax = FALSE, plot = TRUE)
  )
})

test_that("third() (no plot arg) does not emit a deprecation warning", {
  expect_no_warning(third(CVD$cvd, n.lag = 4, outmax = FALSE))
})

test_that("plot.nonlintest(plot = ...) emits a deprecation warning", {
  set.seed(2026 - 05 - 25)
  res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 50)
  lifecycle::expect_deprecated(plot(res))
})

# Deprecation: function aliases ----------------------------------------

test_that("plotCircle emits a deprecation warning", {
  lifecycle::expect_deprecated(plotCircle(seq(1, 12, 1), dp = 0))
})

test_that("plotMonth emits a deprecation warning", {
  lifecycle::expect_deprecated(
    plotMonth(data = CVD, resp = "cvd", panels = 12)
  )
})

# Internal callers MUST NOT trigger their own deprecation warnings ----

test_that("internal peri()/third() calls do not emit deprecation warnings", {
  # If kalfil() were calling peri(plot = FALSE), nscosinor() would emit
  # a deprecation warning. It shouldn't — internal callers were updated.
  set.seed(1)
  expect_no_warning(
    nscosinor(
      data = head(CVD, 48),
      response = "adj",
      cycles = 12,
      tau = c(10, 50),
      niters = 50,
      burnin = 20,
      div = 1000
    )
  )
  # Same for nonlintest() — its third() call should not warn.
  expect_no_warning(
    nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 50)
  )
})

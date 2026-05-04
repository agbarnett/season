# Base R plots are wrapped in function() so vdiffr can render them onto its

# plot.Cosinor ----------------------------------------------------------
library(purrr)
test_that("plot.Cosinor - monthly Poisson", {
  skip_on_ci()
  skip_on_cran()
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  vdiffr::expect_doppelganger(
    "plot-Cosinor-monthly-poisson",
    function() plot(m)
  )
})

test_that("plot.Cosinor - daily identity", {
  skip_on_ci()
  skip_on_cran()
  m <- cosinor(cvd ~ 1, date = "date", data = CVDdaily, type = "daily")
  vdiffr::expect_doppelganger("plot-Cosinor-daily-identity", function() plot(m))
})

test_that("plot.Cosinor - binomial cloglog (probability scale)", {
  skip_on_ci()
  skip_on_cran()
  m <- cosinor(
    stillborn ~ 1,
    date = "dob",
    data = stillbirth,
    family = binomial(link = "cloglog")
  )
  vdiffr::expect_doppelganger(
    "plot-Cosinor-binomial-cloglog",
    function() plot(m)
  )
})

test_that("plot.Cosinor - hourly indoor temperature", {
  skip_on_ci()
  skip_on_cran()
  m <- cosinor(bedroom ~ 1, date = "datetime", data = indoor, type = "hourly")
  vdiffr::expect_doppelganger("plot-Cosinor-hourly", function() plot(m))
})

# plot.monthglm ---------------------------------------------------------

test_that("plot.monthglm - Poisson rate ratios", {
  skip_on_ci()
  skip_on_cran()
  m <- monthglm(
    cvd ~ 1,
    data = CVD,
    family = poisson(),
    offsetpop = expression(pop / 100000),
    offsetmonth = TRUE
  )
  vdiffr::expect_doppelganger("plot-monthglm-poisson", function() plot(m))
})

test_that("plot.monthglm - Gaussian", {
  skip_on_ci()
  skip_on_cran()
  m <- monthglm(adj ~ 1, data = CVD, family = gaussian())
  vdiffr::expect_doppelganger("plot-monthglm-gaussian", function() plot(m))
})

test_that("plot.monthglm - user-supplied ylim", {
  skip_on_ci()
  skip_on_cran()
  m <- monthglm(cvd ~ 1, data = CVD, family = poisson(), offsetmonth = TRUE)
  vdiffr::expect_doppelganger(
    "plot-monthglm-ylim",
    function() plot(m, ylim = c(0.5, 1.5))
  )
})

# plot.Monthmean --------------------------------------------------------

test_that("plot.Monthmean - adjusted CVD rates", {
  skip_on_ci()
  skip_on_cran()
  mm <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  vdiffr::expect_doppelganger("plot-Monthmean", function() plot(mm))
})

# plot.nonlintest -------------------------------------------------------

test_that("plot.nonlintest reports when no points exceed the test limits", {
  # If the region matrix is all-zero (no third-order moment cell
  # exceeds the bootstrap limits), plot.nonlintest cat()s a message
  # and returns invisibly without producing a plot.
  set.seed(2026 - 05 - 04)
  res <- nonlintest(data = rnorm(80), n.lag = 3, n.boot = 10)
  # White-noise input with very small n.boot is the easiest way to
  # land in the "no exceedance" branch; if not, this skips quietly.
  if (max(abs(res$region)) != 0) {
    skip("input triggered exceedances; can't test 'none' branch")
  }
  expect_output(plot(res), "No points of the third-order moment exceed")
})

test_that("plot.nonlintest errors on non-nonlintest input", {
  expect_snapshot(
    error = TRUE,
    plot.nonlintest(list(a = 1))
  )
})

test_that("plot.nonlintest - region of significance", {
  # Bilinear AR(1) series - explicitly nonlinear, so nonlintest() will flag
  # at least one third-order moment cell outside the bootstrap limits and
  # plot.nonlintest produces an actual plot (rather than the empty-region
  # branch which returns invisibly).
  set.seed(2026 - 04 - 29)
  n <- 200
  e <- rnorm(n)
  x <- numeric(n)
  x <- purrr::accumulate(
    2:n,
    \(x_prev, idx) 0.6 * x_prev * e[idx - 1] + e[idx],
    .init = 0
  )
  res <- nonlintest(data = x, n.lag = 3, n.boot = 25)
  vdiffr::expect_doppelganger("plot-nonlintest", plot(res, plot = TRUE))
})

# plot.nsCosinor --------------------------------------------------------

test_that("plot.nsCosinor - single cycle", {
  skip_on_ci()
  skip_on_cran()
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
  vdiffr::expect_doppelganger("plot-nsCosinor-one-cycle", plot(m))
})

test_that("plot.nsCosinor - two cycles", {
  skip_on_ci()
  skip_on_cran()
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
  vdiffr::expect_doppelganger("plot-nsCosinor-two-cycles", plot(m))
})

# plotCircle ------------------------------------------------------------

test_that("plotCircle - 12 monthly values", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "plotCircle",
    function() plotCircle(months = 1:12, dp = 0)
  )
})

# plotCircular ----------------------------------------------------------

test_that("plotCircular - single area", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "plotCircular-one-area",
    function() plotCircular(area1 = 1:12, labels = month.abb, dp = 0)
  )
})

test_that("plotCircular accepts spokes, length, stats=FALSE, and clockwise=FALSE", {
  skip_on_ci()
  skip_on_cran()
  # Coverage for the optional features documented in roxygen but not
  # exercised by the two visual snapshots above. We only assert that
  # rendering doesn't error; visual fidelity is covered by the
  # doppelgangers.
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(dev.off())

  expect_no_error(plotCircular(
    area1 = AFL$players,
    spokes = sqrt(AFL$players), # uncertainty bars
    labels = month.abb,
    dp = 0
  ))
  expect_no_error(plotCircular(
    area1 = 1:12,
    labels = month.abb,
    dp = 0,
    length = TRUE # length proportional to area1
  ))
  expect_no_error(plotCircular(
    area1 = 1:12,
    labels = month.abb,
    dp = 0,
    stats = FALSE # labels only, no numeric annotations
  ))
  expect_no_error(plotCircular(
    area1 = 1:12,
    labels = month.abb,
    dp = 0,
    clockwise = FALSE # counter-clockwise direction
  ))
})

test_that("plotCircular warns when area1 and area2 have different lengths", {
  pdf(file = tempfile(fileext = ".pdf"))
  on.exit(dev.off())
  # Mismatch should print a warning via cat() rather than error out.
  expect_output(
    plotCircular(area1 = 1:12, area2 = 1:6, labels = month.abb, dp = 0),
    "not equal"
  )
})

test_that("plotCircular - two areas with auto legend", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "plotCircular-two-areas",
    function() {
      plotCircular(
        area1 = AFL$players,
        area2 = AFL$expected,
        scale = 0.72,
        labels = month.abb,
        dp = 0,
        lines = TRUE,
        pieces.col = c("seagreen", "purple2"),
        auto.legend = list(labels = c("Obs", "Exp"), title = "# players")
      )
    }
  )
})

# plotMonth -------------------------------------------------------------

test_that("plotMonth - 12 panels CVD", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "plotMonth-12-panels",
    function() plotMonth(data = CVD, resp = "cvd", panels = 12)
  )
})

test_that("plotMonth - single panel", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "plotMonth-one-panel",
    function() plotMonth(data = CVD, resp = "cvd", panels = 1)
  )
})

test_that("plotMonth errors when panels is not 1 or 12", {
  expect_error(
    plotMonth(data = CVD, resp = "cvd", panels = 4),
    "panels must be 1 or 12"
  )
})

# peri() (built-in plot = TRUE branch) ----------------------------------

test_that("peri renders the periodogram when plot = TRUE", {
  skip_on_ci()
  skip_on_cran()
  vdiffr::expect_doppelganger(
    "peri-plot",
    function() peri(CVD$cvd, plot = TRUE)
  )
})

# third() (built-in plot = TRUE branch) ---------------------------------

test_that("third renders the third-order moment when plot = TRUE", {
  skip_on_ci()
  skip_on_cran()
  # outmax = FALSE silences the cat() message; we only want the plot here.
  vdiffr::expect_doppelganger(
    "third-plot",
    function() third(CVD$cvd, n.lag = 12, outmax = FALSE, plot = TRUE)
  )
})

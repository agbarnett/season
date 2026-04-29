# Base R plots are wrapped in function() so vdiffr can render them onto its
# own device. ggplot2 plots are passed directly.

# ---- plot.Cosinor ----------------------------------------------------------

test_that("plot.Cosinor - monthly Poisson", {
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
  m <- cosinor(cvd ~ 1, date = "date", data = CVDdaily, type = "daily")
  vdiffr::expect_doppelganger("plot-Cosinor-daily-identity", function() plot(m))
})

test_that("plot.Cosinor - binomial cloglog (probability scale)", {
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
  m <- cosinor(bedroom ~ 1, date = "datetime", data = indoor, type = "hourly")
  vdiffr::expect_doppelganger("plot-Cosinor-hourly", function() plot(m))
})

# ---- plot.monthglm ---------------------------------------------------------

test_that("plot.monthglm - Poisson rate ratios", {
  m <- monthglm(
    cvd ~ 1,
    data = CVD,
    family = poisson(),
    offsetpop = expression(pop / 100000),
    offsetmonth = TRUE
  )
  vdiffr::expect_doppelganger("plot-monthglm-poisson", function() plot(m))
})

test_that("plot.monthglm - Gaussian (no rate-ratio reference line)", {
  m <- monthglm(adj ~ 1, data = CVD, family = gaussian())
  vdiffr::expect_doppelganger("plot-monthglm-gaussian", function() plot(m))
})

test_that("plot.monthglm - user-supplied ylim", {
  m <- monthglm(cvd ~ 1, data = CVD, family = poisson(), offsetmonth = TRUE)
  vdiffr::expect_doppelganger(
    "plot-monthglm-ylim",
    function() plot(m, ylim = c(0.5, 1.5))
  )
})

# ---- plot.Monthmean --------------------------------------------------------

test_that("plot.Monthmean - adjusted CVD rates", {
  mm <- monthmean(
    data = CVD,
    resp = "cvd",
    offsetpop = expression(pop / 100000),
    adjmonth = "average"
  )
  vdiffr::expect_doppelganger("plot-Monthmean", function() plot(mm))
})

# ---- plot.nonlintest -------------------------------------------------------

test_that("plot.nonlintest - region of significance", {
  # Bilinear AR(1) series - explicitly nonlinear, so nonlintest() will flag
  # at least one third-order moment cell outside the bootstrap limits and
  # plot.nonlintest produces an actual plot (rather than the empty-region
  # branch which returns invisibly).
  set.seed(2026 - 04 - 29)
  n <- 200
  e <- rnorm(n)
  x <- numeric(n)
  for (t in 2:n) x[t] <- 0.6 * x[t - 1] * e[t - 1] + e[t]
  res <- nonlintest(data = x, n.lag = 3, n.boot = 25)
  vdiffr::expect_doppelganger("plot-nonlintest", plot(res, plot = TRUE))
})

# ---- plot.nsCosinor --------------------------------------------------------

test_that("plot.nsCosinor - single cycle", {
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

# ---- plotCircle ------------------------------------------------------------

test_that("plotCircle - 12 monthly values", {
  vdiffr::expect_doppelganger(
    "plotCircle",
    function() plotCircle(months = 1:12, dp = 0)
  )
})

# ---- plotCircular ----------------------------------------------------------

test_that("plotCircular - single area", {
  vdiffr::expect_doppelganger(
    "plotCircular-one-area",
    function() plotCircular(area1 = 1:12, labels = month.abb, dp = 0)
  )
})

test_that("plotCircular - two areas with auto legend", {
  vdiffr::expect_doppelganger(
    "plotCircular-two-areas",
    function()
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
  )
})

# ---- plotMonth -------------------------------------------------------------

test_that("plotMonth - 12 panels CVD", {
  vdiffr::expect_doppelganger(
    "plotMonth-12-panels",
    function() plotMonth(data = CVD, resp = "cvd", panels = 12)
  )
})

test_that("plotMonth - single panel", {
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

# ---- peri() (built-in plot = TRUE branch) ----------------------------------

test_that("peri renders the periodogram when plot = TRUE", {
  vdiffr::expect_doppelganger(
    "peri-plot",
    function() peri(CVD$cvd, plot = TRUE)
  )
})

# ---- third() (built-in plot = TRUE branch) ---------------------------------

test_that("third renders the third-order moment when plot = TRUE", {
  # outmax = FALSE silences the cat() message; we only want the plot here.
  vdiffr::expect_doppelganger(
    "third-plot",
    function() third(CVD$cvd, n.lag = 12, outmax = FALSE, plot = TRUE)
  )
})

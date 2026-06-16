# nscosinor is MCMC-based and slow. Tests use tiny niters to verify
# input validation and output structure — not MCMC convergence.

test_that("nscosinor rejects malformed inputs", {
  expect_snapshot(
    error = TRUE,
    nscosinor(
      data = data.frame(adj = 1:24),
      response = "adj",
      cycles = 12,
      tau = c(10, 50)
    )
  )
  expect_snapshot(
    error = TRUE,
    nscosinor(data = CVD, response = "adj", cycles = 12, tau = 10)
  )
  expect_snapshot(
    error = TRUE,
    nscosinor(data = CVD, response = "adj", cycles = 0, tau = c(10, 50))
  )
  expect_snapshot(
    error = TRUE,
    nscosinor(
      data = CVD,
      response = "adj",
      cycles = 12,
      tau = c(10, 50),
      niters = 10,
      burnin = 100
    )
  )

  cvd_na <- CVD
  cvd_na$adj[1] <- NA
  expect_snapshot(
    error = TRUE,
    nscosinor(data = cvd_na, response = "adj", cycles = 12, tau = c(10, 50))
  )
})

test_that("nscosinor returns mean that is between lower and upper bounds", {
  set.seed(2026 - 05 - 18)
  res <- nscosinor(
    data = head(CVD, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000
  )

  is_between <- function(x, lower, upper) {
    (x >= lower) & (x <= upper)
  }

  fitted_btn <- with(res$fitted.values, is_between(mean, lower, upper))
  expect_all_true(fitted_btn)

  oseason_btn <- with(res$oseason, is_between(mean, lower, upper))
  expect_all_true(oseason_btn)

  season_btn <- with(res$season, is_between(mean, lower, upper))
  expect_all_true(season_btn)

  trend_btn <- with(res$trend, is_between(mean, lower, upper))
  expect_all_true(trend_btn)
})

test_that("nscosinor returns an nsCosinor object with the documented fields", {
  set.seed(2026 - 04 - 29)
  res <- nscosinor(
    data = head(CVD, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000
  )
  expect_s3_class(res, "nsCosinor")
  expect_named(
    res,
    c(
      "call",
      "time",
      "trend",
      "season",
      "oseason",
      "fitted.values",
      "residuals",
      "n",
      "chains",
      "cycles"
    )
  )
  expect_identical(res$n, 60L)
})

test_that("nscosinor MCMC chain has the expected dimensions and names", {
  # The chain is a coda::mcmc with (niters - burnin) rows and
  # 1 + 3 * length(cycles) columns: std.error, std.season*, phase*, amplitude*.
  set.seed(2026 - 04 - 29)
  n_iter <- 50L
  burn_in <- 20L
  res <- nscosinor(
    data = head(CVD, 48),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = n_iter,
    burnin = burn_in,
    div = 1000
  )
  expect_s3_class(res$chains, "mcmc")
  expect_identical(dim(res$chains), c(n_iter - burn_in, 4L))
  expect_identical(
    colnames(res$chains),
    c("std.error", "std.season1", "phase1", "amplitude1")
  )
})

test_that("nscosinor handles two seasonal cycles", {
  set.seed(2026 - 04 - 29)
  cycle_vec <- c(6, 12)
  res <- nscosinor(
    data = head(CVD, 48),
    response = "adj",
    cycles = cycle_vec,
    tau = c(10, 50, 50),
    niters = 50,
    burnin = 20,
    div = 1000
  )
  expect_identical(res$cycles, cycle_vec)
  expect_identical(ncol(res$chains), as.integer(1 + 3 * 2))
  expect_identical(ncol(res$season), as.integer(3 * 2))
  # expect that we get back 2 sets of columns
  expect_identical(ncol(res$season), as.integer(length(cycle_vec) * 3))

  # Don't snapshot the MCMC trajectory itself — BLAS/LAPACK varies by
  # platform (Accelerate on mac, OpenBLAS on Linux, Rblas on Windows)
  # and tiny per-operation differences compound through ~50 iterations
  # of mvrnorm/qr.solve/%*% into visibly different summary quantiles.
  # Verify structure and well-formedness instead.
  season <- res$season
  expect_identical(dim(season), c(nrow(head(CVD, 48)), 6L))
  expect_true(all(is.finite(unlist(season))))

  # `season` columns repeat (mean, lower, upper) per cycle, so every
  # 3rd column starting at 1/2/3 is a mean/lower/upper. Flatten and
  # check all means are bracketed by their CI in one expectation.
  means <- unlist(season[, seq(1, ncol(season), by = 3)])
  lowers <- unlist(season[, seq(2, ncol(season), by = 3)])
  uppers <- unlist(season[, seq(3, ncol(season), by = 3)])
  expect_all_true(means >= lowers & means <= uppers)
})


test_that("nscosinor works appropriately for different year/month columns", {
  CVD_diff <- CVD
  names(CVD_diff) <- c(
    "yr",
    "mn",
    "yrmon",
    "cvd",
    "tmpd",
    "pop",
    "ndaysmonth",
    "adj"
  )

  set.seed(2026 - 06 - 16)
  res_yrmn <- nscosinor(
    data = head(CVD_diff, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000,
    year_var = "yr",
    month_var = "mn"
  )

  set.seed(2026 - 06 - 16)
  res_og <- nscosinor(
    data = head(CVD, 60),
    response = "adj",
    cycles = 12,
    tau = c(10, 50),
    niters = 60,
    burnin = 30,
    div = 1000
  )

  expect_equal(res_yrmn$trend, res_og$trend)
  expect_equal(res_yrmn$season, res_og$season)
  expect_equal(res_yrmn$oseason, res_og$oseason)
  expect_equal(res_yrmn$fitted.values, res_og$fitted.values)
})

test_that("nscosinor fails when year/month columns don't exist", {
  expect_snapshot(
    error = TRUE,
    nscosinor(
      data = head(CVD, 60),
      response = "adj",
      cycles = 12,
      tau = c(10, 50),
      niters = 60,
      burnin = 30,
      div = 1000,
      year_var = "yr",
      month_var = "mn"
    )
  )
})

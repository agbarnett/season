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
  expect_identical(res$n, 60)
})

test_that("nscosinor MCMC chain has the expected dimensions and names", {
  # The chain is a coda::mcmc with (niters - burnin) rows and
  # 1 + 3 * length(cycles) columns: std.error, std.season*, phase*, amplitude*.
  set.seed(2026 - 04 - 29)
  n_iter <- 50
  burn_in <- 20
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
  expect_identical(dim(res$chains), c(n_iter - burn_in, 4))
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
  expect_identical(ncol(res$chains), 1 + 3 * 2)
  expect_identical(ncol(res$season), 3 * 2)
})

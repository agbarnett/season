# nonlintest is bootstrap-heavy: each call runs n.boot * 3 AAFT surrogates
# through third(). Use a small n.boot here — these tests check the pipeline
# runs and the output is shape-stable, not statistical power.

test_that("nonlintest returns an object with the documented fields", {
  set.seed(2026 - 04 - 29)
  res <- nonlintest(data = rnorm(80), n.lag = 4, n.boot = 10)

  expect_s3_class(res, "nonlintest")
  expect_named(res, c("stats", "region", "diff_l", "diff_u", "n.lag"))
  # region/diff_l/diff_u are (n.lag + 1) x (n.lag + 1) matrices.
  expect_equal(dim(res$region), c(5, 5))
})

test_that("nonlintest output is stable for a fixed seed", {
  set.seed(2026 - 04 - 29)
  res <- nonlintest(data = rnorm(100), n.lag = 3, n.boot = 25)
  expect_snapshot(res$stats)
})

make_stillbirth_freqs <- function() {
  freqs <- table(stillbirth$month, stillbirth$stillborn)
  list(
    trials = as.numeric(freqs[, 1] + freqs[, 2]),
    success = as.numeric(freqs[, 2])
  )
}

stillbirth_freqs <- make_stillbirth_freqs()

test_that("wtest output has the documented shape", {
  res <- wtest(cases = "success", offset = "trials", data = stillbirth_freqs)
  expect_named(res, c("test", "pvalue"))
  expect_snapshot(res)
})

test_that("wtest reproduces the published stillbirth result", {
  # Anchored to Barnett & Dobson (2010) p.83: X^2 = 6.90, p-value = 0.032.
  res <- wtest(
    cases = "success",
    offset = "trials",
    data = stillbirth_freqs
  )
  expect_snapshot(res)
})

test_that("wtest gives a non-significant p-value for flat monthly counts", {
  d <- list(trials = rep(1000, 12), success = rep(50, 12))
  res <- wtest(cases = "success", offset = "trials", data = d)
  expect_gt(res$pvalue, 0.5)
})

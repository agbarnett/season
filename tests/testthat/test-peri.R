test_that("peri returns the documented periodogram outputs", {
  peri_output <- peri(CVD$cvd, plot = FALSE)
  expect_named(peri_output, c("peri", "f", "c", "amp", "phase"))

  # Each output vector has length n/2 + 1; the first cycle is undefined.
  n_cvd <- length(CVD$cvd)
  expect_length(peri_output$peri, n_cvd / 2 + 1)
  expect_true(is.na(peri_output$c[1]))
  expect_identical(peri_output$f[1], 0)
})

test_that("peri's largest periodogram peak lands on the seeded cycle length", {
  # Pure cosine with period 12 over n = 288 — the peak in p$peri must fall
  # at the index where the cycle column equals 12.
  period_12 <- 12
  x <- 5 * cos(2 * pi * seq_len(288) / period_12)
  peri_output <- peri(x, plot = FALSE)
  non_na <- which(!is.na(peri_output$c))
  peri_non_missing <- peri_output$peri[non_na]
  peri_max_idx <- which.max(peri_non_missing)
  expect_identical(
    peri_output$c[non_na[peri_max_idx]],
    period_12
  )
})

test_that("peri keeps the DC component when adjmean = FALSE", {
  # A noisy series with non-zero mean: the zero-frequency bin should hold
  # mean energy when adjmean is off and (effectively) zero when on. Noise
  # avoids the all-zero bins that trip up peri()'s phase loop.
  set.seed(2026 - 04 - 29)
  x <- 10 + stats::rnorm(64, sd = 0.5)
  expect_lt(peri(x, adjmean = TRUE, plot = FALSE)$peri[1], 1e-8)
  expect_gt(peri(x, adjmean = FALSE, plot = FALSE)$peri[1], 0)
})

test_that("peri output is numerically stable for a known input", {
  peri_output <- peri(CVD$cvd, plot = FALSE)$peri |> round(4)
  expect_snapshot(peri_output)
})

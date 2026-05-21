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

# phase coverage -----------------------------------------------------
# The phase loop in peri() is the most likely thing to drift under a
# rewrite (it has four sign branches and a manual wrap-around).
# These tests pin the documented behaviour so any rewrite must match.

test_that("peri leaves the boundary phase bins at zero", {
  # The inner loop runs for j in 2:(n_fft - 1), so phase[1] and phase[n_fft]
  # are left at their initialised value of 0.
  # Pin this so any rewrite preserves the boundary behaviour exactly.
  peri_output <- peri(CVD$cvd, plot = FALSE)
  n_fft <- length(peri_output$phase)
  expect_identical(peri_output$phase[1], 0)
  expect_identical(peri_output$phase[n_fft], 0)
})

test_that("peri recovers the phase of a pure cosine at its peak frequency", {
  # cos(2*pi*s/12) sampled at s = 1, ..., 288. The DFT picks up a
  # phase offset of -pi/6 from the t = 1 (not t = 0) start, and the
  # `imaginary_part <- -Im(...)` sign flip then `atan2 %% (2*pi)`
  # lands at 11*pi/6. This is the canonical "pure cos" answer for
  # this package's sign convention.
  n <- 288
  period <- 12
  x <- 5 * cos(2 * pi * seq_len(n) / period)
  peri_output <- peri(x, plot = FALSE)
  peak <- which.max(peri_output$peri)
  expect_identical(peri_output$c[peak], period)
  expect_equal(peri_output$phase[peak], 11 * pi / 6, tolerance = 1e-6)
})

test_that("peri recovers the phase of a pure sine at its peak frequency", {
  # Same input shape as above, but sin instead of cos. Under this
  # package's sign convention the phase at the peak is pi/3. This
  # is the other quadrant the phase loop has to reach correctly.
  n <- 288
  period <- 12
  x <- 5 * sin(2 * pi * seq_len(n) / period)
  peri_output <- peri(x, plot = FALSE)
  peak <- which.max(peri_output$peri)
  expect_identical(peri_output$c[peak], period)
  expect_equal(peri_output$phase[peak], pi / 3, tolerance = 1e-6)
})

test_that("peri's phase output is in [0, 2pi) at every bin", {
  # Catches any rewrite that drops the wrap-around step.
  peri_output <- peri(CVD$cvd, plot = FALSE)
  expect_true(all(peri_output$phase >= 0))
  expect_true(all(peri_output$phase < 2 * pi + 1e-9))
})

test_that("peri's phase output is numerically stable for a known input", {
  # Regression-catch for the full phase vector. If the rewrite drifts
  # at any frequency bin, this snapshot will flag it.
  peri_phase <- peri(CVD$cvd, plot = FALSE)$phase |> round(4)
  expect_snapshot(peri_phase)
})

test_that("peri's amplitude output is numerically stable for a known input", {
  # The amp field isn't touched by the phase rewrite, but pinning it
  # gives a cheap regression check against any drift in the FFT path
  # that feeds into both amp and phase.
  peri_amp <- peri(CVD$cvd, plot = FALSE)$amp |> round(4)
  expect_snapshot(peri_amp)
})

test_that("peri accepts odd-length input", {
  # The function pads odd-length data with the mean before the FFT,
  # but `n_fft` is still derived from the original (odd) n. For odd
  # n the output length is floor(n / 2) + 1 because R's `:` operator
  # truncates the non-integer `n_fft = n/2 + 1`. Untested before;
  # adding it so a future rewrite can't silently break the odd path.
  set.seed(2026 - 04 - 30)
  x <- stats::rnorm(63)
  expect_no_error(out <- peri(x, plot = FALSE))
  expect_length(out$peri, floor(length(x) / 2) + 1)
})

# 2000 normal samples, centred on zero
set.seed(2026 - 04 - 28)
theta <- stats::rnorm(n = 2000, mean = 0, sd = pi / 50)
# hist(theta, breaks = seq(-pi / 8, pi / 8, pi / 30))
theta_ciphase <- ciPhase(theta)

## Expected outputs were determined by calculating +/-(pi/2)*0.95 as the
## hypothetical Quantiles for a unit circle uniformly populated (and saturated)
## on its right hand side. This yields a 95% Confidence interval 0f +/-1.492257
## the vector constructed above is arbitrarily close to this when run through
## ciPhase, so current outputs are hardcoded in as the expected outputs.
example_ciphase <- ciPhase(
  c((seq(0, pi / 2, pi / 100000)), (seq(3 * pi / 2, 2 * pi, pi / 100000))),
  alpha = 0.05
)

test_that("Mean and Confidence Interval is consistent", {
  expect_identical(example_ciphase$mean, 0)
  expect_equal(example_ciphase$lower, -1.4922564, tolerance = 0.00001)
  expect_equal(example_ciphase$upper, 1.4922564, tolerance = 0.00001)
  expect_equal(theta_ciphase$mean, -0.001463524, tolerance = 0.00001)
  expect_equal(theta_ciphase$lower, -0.1214996, tolerance = 0.00001)
  expect_equal(theta_ciphase$upper, 0.1175619, tolerance = 0.00001)
})

# Silence `lifecycle::deprecate_warn()` for the test suite as a whole.
# Individual tests that specifically *check* the deprecation warning still
# fire (e.g., in test-autoplot.R) — `lifecycle::expect_deprecated()` works
# by listening for the warning's class, not by the verbosity option.
#
# Without this, the existing snapshot tests in test-plots.R that call the
# now-deprecated `plot.Cosinor()` / `plot.monthglm()` / `plotCircle()` /
# `plotMonth()` etc. would fail with "unexpected warning" under
# testthat edition 3.
withr::local_options(
  lifecycle_verbosity = "quiet",
  .local_envir = testthat::teardown_env()
)

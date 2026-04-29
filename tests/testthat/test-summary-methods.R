# Each summary method assembles a class-specific list, then dispatches
# to its print method. The shape and printed form are exactly what users
# see, so snapshots are the right tool for verification.

test_that("summary.Cosinor builds the documented summary.Cosinor object", {
  m <- cosinor(
    cvd ~ 1,
    date = "month",
    data = CVD,
    type = "monthly",
    family = poisson(),
    offsetmonth = TRUE
  )
  s <- summary(m)
  expect_s3_class(s, "summary.Cosinor")
  expect_snapshot(s)
})

test_that("summary.Cosinor errors on non-Cosinor input", {
  expect_snapshot(
    error = TRUE,
    summary.Cosinor(list(a = 1))
  )
})

test_that("summary.monthglm builds the documented summary.monthglm object", {
  m <- monthglm(
    cvd ~ 1,
    data = CVD,
    family = poisson(),
    offsetpop = expression(pop / 100000),
    offsetmonth = TRUE
  )
  s <- summary(m)
  expect_s3_class(s, "summary.monthglm")
  expect_snapshot(round(s$month.ests, 4))
})

test_that("summary.monthglm picks the right month.effect label per family", {
  # poisson -> "RR" (rate ratios), binomial -> "OR" (odds ratios), gaussian -> "".
  CVD$success <- CVD$cvd
  CVD$failure <- CVD$ndaysmonth * 100 - CVD$cvd

  expect_equal(
    summary(monthglm(cvd ~ 1, data = CVD, family = poisson()))$month.effect,
    "RR"
  )
  expect_equal(
    summary(monthglm(
      cbind(success, failure) ~ 1,
      data = CVD,
      family = binomial()
    ))$month.effect,
    "OR"
  )
  expect_equal(
    summary(monthglm(adj ~ 1, data = CVD, family = gaussian()))$month.effect,
    ""
  )
})

test_that("summary.monthglm errors on non-monthglm input", {
  expect_error(summary.monthglm(list(a = 1)), "must be of class 'monthglm'")
})

test_that("summary.nsCosinor builds the documented summary.nsCosinor object", {
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
  s <- summary(m)
  expect_s3_class(s, "summary.nsCosinor")
  expect_named(s, c("cycles", "niters", "burnin", "tau", "stats"))
  expect_named(s$stats, c("errorstats", "wstats", "ampstats", "phasestats"))
})

test_that("summary.nsCosinor errors on non-nsCosinor input", {
  expect_snapshot(
    error = TRUE,
    summary.nsCosinor(list(a = 1))
  )
})

test_that("summary.casecross prints a structured report", {
  m <- casecross(
    cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
    data = subset(CVDdaily, date <= as.Date("1987-12-31"))
  )
  expect_snapshot(summary(m))
})

test_that("summary.casecross errors on non-casecross input", {
  expect_error(summary.casecross(list(a = 1)), "must be of class 'casecross'")
})

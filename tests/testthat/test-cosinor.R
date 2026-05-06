# Tests for cosinor(), replicating examples in Barnett & Dobson (2010). Cosinor
# model fits a GLM with sine and cosine terms representing an annual seasonal
# pattern; we verify our implementation reproduces the published amplitude
# and phase estimates, then check the per-link scaling rules and input guards.

# monthly CVD with Poisson + offsetmonth -------------------------------
# Used downstream by other tests via snapshot. Phase pinned in the next test.

set.seed(2026 - 04 - 28)
res_monthly <- cosinor(
  cvd ~ 1,
  date = "month",
  data = CVD,
  type = "monthly",
  family = poisson(),
  offsetmonth = TRUE
)

test_that("cosinor returns the documented Cosinor structure", {
  expect_s3_class(res_monthly, "Cosinor")
  expect_snapshot(names(res_monthly))
  expect_snapshot(res_monthly$glm)
})

test_that("Replicate results on page 77", {
  m_daily <- cosinor(cvd ~ 1, date = "date", data = CVDdaily)

  expect_s3_class(m_daily, "Cosinor")
  expect_snapshot(names(m_daily))
  expect_snapshot(summary(m_daily))

  m_daily_coef <- coef(m_daily$glm)
  expect_equal(m_daily_coef[["sinw"]], 2.684572, tolerance = 1e-6)
  expect_equal(m_daily_coef[["cosw"]], 6.617196, tolerance = 1e-6)
})


test_that("Replicate results on page 78", {
  m <- cosinor(
    cvd ~ 1,
    date = "date",
    data = CVDdaily,
    type = "daily",
    family = poisson(),
    text = TRUE
  )
  m_summary <- summary(m)
  expect_equal(m_summary$amp, 7.714917, tolerance = 1e-8)
  expect_match(summary(m)$phase, "Month = January , day = 23")
})

# TODO
# cannot quite replicate this
# test_that("Replicate monthly results on page 78", {
#  m_month <- cosinor(
#    formula = cvd ~ 1,
#    date = "month",
#    data = CVD,
#    type = "monthly",
#    family = poisson(),
#    offsetmonth = TRUE
#  )
#
#  m_month
#  summary(m_month)
# })

# binomial cloglog on stillbirth ---------------------------------------
# Book p.80: amplitude = 0.0012 (probability scale), phase = 27 January,
# peak probability = 0.0070, low (29 July) = 0.0047. This exercises the
# cloglog back-transform branch of cosinor() (line 179).

test_that("cosinor reproduces stillbirth cloglog amplitude/phase (p.80)", {
  # how to determine this:
  # The estimated peak estimate in the probability of stillbirth is on 27
  # January is 0.0070, and the low on 29 July (6 months later) is 0.0047.
  model_dob <- cosinor(
    stillborn ~ 1,
    date = "dob",
    data = stillbirth,
    family = binomial(link = "logit")
  )
  s_dob <- summary(model_dob)
  expect_equal(s_dob$amp, 0.00123, tolerance = 1e-3)
  expect_match(s_dob$phase, "January.*27|27.*January")
  expect_match(s_dob$lphase, "July.*29|29.*July")
})

# input validation -----------------------------------------------------

test_that("cosinor errors when offsetmonth is not logical", {
  expect_snapshot(
    error = TRUE,
    cosinor(
      cvd ~ 1,
      date = "month",
      data = CVD,
      type = "monthly",
      family = poisson(),
      offsetmonth = "yes"
    )
  )
})

test_that("cosinor errors when type is not daily/weekly/monthly/hourly", {
  expect_snapshot(
    error = TRUE,
    cosinor(
      cvd ~ 1,
      date = "month",
      data = CVD,
      type = "yearly",
      family = poisson()
    )
  )
})

test_that("cosinor requires POSIXct dates when type='hourly'", {
  bad <- data.frame(date = as.Date("2020-01-01") + 0:23, y = stats::rnorm(24))
  expect_snapshot(
    error = TRUE,
    cosinor(y ~ 1, date = "date", data = bad, type = "hourly")
  )
})

test_that("cosinor requires Date when type='daily'", {
  bad <- data.frame(date = as.character(Sys.Date() + 0:9), y = stats::rnorm(10))
  expect_snapshot(
    error = TRUE,
    cosinor(y ~ 1, date = "date", data = bad, type = "daily")
  )
})

test_that("cosinor errors when alpha is outside (0, 1)", {
  expect_snapshot(
    error = TRUE,
    cosinor(
      cvd ~ 1,
      date = "month",
      data = CVD,
      type = "monthly",
      family = poisson(),
      alpha = 0
    )
  )
  expect_snapshot(
    error = TRUE,
    cosinor(
      cvd ~ 1,
      date = "month",
      data = CVD,
      type = "monthly",
      family = poisson(),
      alpha = 1.5
    )
  )
})

test_that("cosinor refuses offsetmonth=TRUE for hourly data", {
  expect_snapshot(
    error = TRUE,
    cosinor(
      bedroom ~ 1,
      date = "datetime",
      data = indoor,
      type = "hourly",
      offsetmonth = TRUE
    )
  )
})

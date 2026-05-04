test_that("monthglm returns a monthglm object whose coefficients are stable", {
  m <- monthglm(
    cvd ~ 1,
    data = CVD,
    family = poisson(),
    offsetpop = expression(pop / 100000),
    offsetmonth = TRUE
  )
  expect_s3_class(m, "monthglm")
  expect_named(m, c("call", "glm", "fitted.values", "residuals"))
  expect_snapshot(coef(m$glm))
})

test_that("monthglm rejects refmonth outside 1:12", {
  expect_snapshot(
    error = TRUE,
    monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 0)
  )
  expect_snapshot(
    error = TRUE,
    monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 13)
  )
})

test_that("monthglm fails when invalid family used", {
  expect_snapshot(
    error = TRUE,
    monthglm(cvd ~ 1, data = CVD, family = fish(), refmonth = 1)
  )
})

test_that("monthglm fails when invalid monthvariable used", {
  expect_snapshot(
    error = TRUE,
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      monthvar = "year"
    )
  )
})

test_that("monthglm offsets work and fail appropriately", {
  expect_silent(
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetpop = expression(pop / 1000)
    )
  )
  expect_snapshot(
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetpop = expression(pop)
    )
  )
  expect_snapshot(
    error = TRUE,
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetpop = expression(bananas)
    )
  )
  expect_silent(
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetmonth = TRUE
    )
  )
  expect_silent(
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetmonth = FALSE
    )
  )
  expect_snapshot(
    error = TRUE,
    monthglm(
      cvd ~ 1,
      data = CVD,
      family = poisson(),
      refmonth = 1,
      offsetmonth = "January"
    )
  )
})

test_that("monthglm omits the reference month from the coefficients", {
  # 12 months − 1 reference = 11 month terms, plus the intercept.
  m_jan <- monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 1)
  m_jul <- monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 7)

  expect_length(grep("^months", names(coef(m_jan$glm))), 11)
  expect_false("monthsJan" %in% names(coef(m_jan$glm)))
  expect_false("monthsJul" %in% names(coef(m_jul$glm)))
})

cvd_test <- head(CVD$cvd, 50)
surr_1 <- aaft(data = cvd_test, nsur = 1)
surr_5 <- aaft(data = cvd_test, nsur = 5)
# plot(cvd_test, type = 'l')
# lines(surr_1[, 1], col = 'red')

test_that("aaft returns correct dimension", {
  expect_equal(dim(surr_1), c(50, 1))
  expect_equal(dim(surr_5), c(50, 5))
})

test_that("aaft returns a different set of numbers to input", {
  expect_false(identical(cvd_test, as.numeric(surr_1)))
  expect_false(identical(cvd_test, as.numeric(surr_5[, 1])))
  expect_false(identical(cvd_test, as.numeric(surr_5[, 2])))
  expect_false(identical(cvd_test, as.numeric(surr_5[, 3])))
  expect_false(identical(cvd_test, as.numeric(surr_5[, 4])))
  expect_false(identical(cvd_test, as.numeric(surr_5[, 5])))
})

test_that("aaft returns same second order characteristics", {
  expect_equal(var(cvd_test), var(surr_1), ignore_attr = TRUE)
  expect_equal(mean(cvd_test), mean(surr_1), ignore_attr = TRUE)
  expect_equal(sd(cvd_test), sd(surr_1), ignore_attr = TRUE)

  expect_all_equal(
    object = apply(surr_5, MARGIN = 2, FUN = var),
    expected = var(cvd_test)
  )

  expect_all_equal(
    object = apply(surr_5, MARGIN = 2, FUN = mean),
    expected = mean(cvd_test)
  )

  expect_all_equal(
    object = apply(surr_5, MARGIN = 2, FUN = sd),
    expected = sd(cvd_test)
  )
})

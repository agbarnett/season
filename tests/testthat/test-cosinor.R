## cardiovascular disease data (offset based on number of days in...
## ...the month scaled to an average month length)
set.seed(2026 - 04 - 28)
res <- cosinor(
  cvd ~ 1,
  date = "month",
  data = CVD,
  type = "monthly",
  family = poisson(),
  offsetmonth = TRUE
)

test_that("cosinor produces the right output type", {
  expect_snapshot(names(res))
  expect_snapshot(summary(res$residuals))
  expect_snapshot(summary(res$fitted.values))
  expect_snapshot(summary(res$fitted.plus))
  expect_snapshot(res$glm)
})
#
# ## stillbirth data
# res_sb = cosinor(
#   stillborn ~ 1,
#   date = 'dob',
#   data = stillbirth,
#   family = binomial(link = 'cloglog')
# )
# summary(res_sb)
# plot(res_sb)
#
# ## hourly indoor temperature data
# res_indoor_t = cosinor(
#   bedroom ~ 1,
#   date = 'datetime',
#   type = 'hourly',
#   data = indoor
# )
# summary(res_indoor_t)
# # to get the p-values for the sine and cosine estimates
# summary(res_indoor_t$glm)
#

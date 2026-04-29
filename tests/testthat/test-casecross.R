# head(CVDdaily)
# subset for example
CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
# Effect of ozone on CVD death
model1 <- casecross(
  cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
  data = CVDdaily
)
# summary(model1)

test_that("overall structure of the casecross model is consistent", {
  expect_snapshot(model1)
  expect_snapshot(names(model1))
  expect_snapshot(model1$c.model)
})
names(model1)

# # match on day of the week
# model2 <- casecross(cvd ~ o3mean + tmpd, matchdow = TRUE, data = CVDdaily)
# summary(model2)
# # match on temperature to within a degree
# model3 = casecross(
#   cvd ~ o3mean + Mon + Tue + Wed + Thu + Fri + Sat,
#   data = CVDdaily,
#   matchconf = 'tmpd',
#   confrange = 1
# )
# summary(model3)

a <- ciPhase(c((seq(0,pi/2,pi/1000)),(seq(3*pi/2,2*pi,pi/1000))),alpha=0.05)


test_that("Mean and Confidence Interval is Correct", {
  expect_equal(a$mean,0)
  expect_equal(a$lower,-1.492178)
  expect_equal(a$upper,1.492178)
})
## Justify numbers
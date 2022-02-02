data("CVD")

test_that("flagleap works", {
  expect_equal(flagleap(CVD)$ndaysmonth[2],28) # Feb
  expect_equal(flagleap(CVD)$ndaysmonth[158], 29) # leap Feb
  expect_equal(flagleap(CVD)$month[2],2) 
  expect_equal(flagleap(CVD)$month[158],2)
  expect_equal(flagleap(CVD)$year[2],1987)
  expect_equal(flagleap(CVD)$year[158],2000)
})
## Checks that flagleap can distinguish leap months from regular months (Feb), 
## and correctly identify year and month.
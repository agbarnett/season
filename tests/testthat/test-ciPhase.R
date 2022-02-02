a<-ciPhase(c((seq(0,pi/2,pi/100000)),(seq(3*pi/2,2*pi,pi/100000))),alpha=0.05)


test_that("Mean and Confidence Interval is Correct", {
  expect_equal(a$mean,0)
  expect_equal(a$lower,-1.4922564)
  expect_equal(a$upper,1.4922564)
})
## Expected outputs were determined by calculating +/-(pi/2)*0.95 as the hypothetical 
## Quantiles for a unit circle uniformly populated (and saturated) on its right hand side. 
##This yields a 95% Confidence interval 0f +/-1.492257
## the vector constructed above is arbitrarily close to this when run through ciPhase,
##so current outputs are hardcoded in as the expected outputs.  

cvd<-c(1831, 1361, 1569, 1454, 1447)
month<-c(1, 2, 3, 4, 5)
year<-c(1987, 1987, 1987,1987, 1987)
data<-cbind(cvd,month,year)
ratio<-30/c(31,28,31,30,31)
expected<- (ratio*cvd)

test_that("monthglm works", {
  expect_equal((monthmean(data=CVD[1:5,],resp="cvd",adjmonth="thirty"))$mean[1:5],expected)
})

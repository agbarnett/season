c<-matrix(0,5,5)
c[1,]<- c(45,26,12.8,4.8,1)
c[2,]<-c(26,34,18,7.6,2)
c[3,]<-c(12.8,18,23.2,10.4,3)
c[4,]<-c(4.8,7.6,10.4,13.2,4)
c[5,]<-c(1,2,3,4,5)
d<-third(c(1:5),n.lag=5,centre=FALSE)

test_that("Moment estimation matrix is correct", {
  expect_equal(d$third[6:10,6:10], c)
})
## test if third works for a simple vector for numbers 1-5, 
## expected matrix assembled within test but constructed elsewhere due to lengthy code
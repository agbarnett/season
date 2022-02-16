cvd<-c(55, 73, 64, 57, 56, 57, 56, 56, 55, 55, 73)
o3mean<-c(16.0073, -11.6595, -10.3241, -18.6471, -17.5291, -18.6471, -17.5291,
 -17.5291, -16.0073, -16.0073, -11.659)
tmpd<-c(54.50, 58.50, 55.25, 54.75, 54.50, 54.75, 54.50, 54.50, 54.50, 54.50, 58.50)
date<-c("1987-01-01", "1987-01-02", "1987-01-03", "1987-01-04", "1987-01-05",
 "1987-01-04", "1987-01-05", "1987-01-05", "1987-01-01", "1987-01-01",
 "1987-01-02")
case<-c(1,1,1,1,1,0,0,0,0,0,0)
timex<-c(1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2)
time<-c(1, 2, 3, 4, 5, 1, 1, 2, 4, 5, 5)
diffdays<-c(NA,NA,NA,NA,NA,3,4,3,3,4,3)
outcome<-c(55, 73, 64, 57, 56, 55, 55, 73, 57, 56, 56)
test.frame<-cbind(cvd,o3mean,tmpd,date,case,timex,time,diffdays,outcome)
final.formula<-as.formula(paste('Surv(timex,case)~',indep,'+strata(time)'))

test.model<-coxph(finalformula,
                            weights = outcome,
                            data = finished,method = c("breslow"))
Casecross<-casecross(cvd~ o3mean+tmpd,data=CVDdaily[1:5,],exclusion=2)

test_that("Casecross works", {
  expect_equal(g$c.model$coefficients,test.model$coefficients)
})
## dataframe above was not constructed a-priori.  
## Code from casecross was taken and used to construct the dataframe, 
## dataframe was assessed visually to ensure the correct controls were included for the exclusion value,
## cases and controls were marked 1,0 accordingly, 
## and each day had the correct values for the dependent and independent variables. 
## the dataframe is run through the model 
## and outputs are compared to casecross to test future changes in functionality.







# cosinor returns the documented Cosinor structure

    Code
      names(res_monthly)
    Output
      [1] "call"          "glm"           "fitted.plus"   "fitted.values"
      [5] "residuals"     "date"         

---

    Code
      res_monthly$glm
    Output
      
      Call:  glm(formula = f, family = family, data = data, offset = offset)
      
      Coefficients:
      (Intercept)         cosw         sinw  
          7.21933      0.15552      0.02237  
      
      Degrees of Freedom: 167 Total (i.e. Null);  165 Residual
      Null Deviance:	    4330 
      Residual Deviance: 1496 	AIC: 3023

# Replicate results on page 77

    Code
      names(m_daily)
    Output
      [1] "call"          "glm"           "fitted.plus"   "fitted.values"
      [5] "residuals"     "date"         

---

    Code
      summary(m_daily)
    Output
      Cosinor test:
      Number of observations = 5114 
      Amplitude = 7.14  
      Phase: Month = January , day = 23 
      Low point: Month = July , day = 25 
      Significant seasonality based on adjusted significance level of 0.025  =  TRUE 
      
      Regression coefficients:
                   Estimate Std..Error   t.value      Pr...t..
      (Intercept) 45.110481  0.1144621 394.10845  0.000000e+00
      cosw         6.617196  0.1618739  40.87872 2.466596e-316
      sinw         2.684572  0.1618739  16.58435  3.305908e-60

# cosinor errors when offsetmonth is not logical

    Code
      cosinor(cvd ~ 1, date = "month", data = CVD, type = "monthly", family = poisson(),
      offsetmonth = "yes")
    Condition
      Error in `cosinor()`:
      ! Error: 'offsetmonth' must be of type logical

# cosinor errors when type is not one of daily/weekly/monthly/hourly

    Code
      cosinor(cvd ~ 1, date = "month", data = CVD, type = "yearly", family = poisson())
    Condition
      Error in `cosinor()`:
      ! type must be daily, weekly, monthly or hourly

# cosinor requires POSIXct dates when type='hourly'

    Code
      cosinor(y ~ 1, date = "date", data = bad, type = "hourly")
    Condition
      Error in `cosinor()`:
      ! date variable must be of class POSIXct when type='hourly'

# cosinor requires Date when type='daily'

    Code
      cosinor(y ~ 1, date = "date", data = bad, type = "daily")
    Condition
      Error in `cosinor()`:
      ! date variable must be of class Date when type='daily'

# cosinor errors when alpha is outside (0, 1)

    Code
      cosinor(cvd ~ 1, date = "month", data = CVD, type = "monthly", family = poisson(),
      alpha = 0)
    Condition
      Error in `cosinor()`:
      ! alpha must be between 0 and 1

---

    Code
      cosinor(cvd ~ 1, date = "month", data = CVD, type = "monthly", family = poisson(),
      alpha = 1.5)
    Condition
      Error in `cosinor()`:
      ! alpha must be between 0 and 1

# cosinor refuses offsetmonth=TRUE for hourly data

    Code
      cosinor(bedroom ~ 1, date = "datetime", data = indoor, type = "hourly",
      offsetmonth = TRUE)
    Condition
      Error in `cosinor()`:
      ! do not use monthly offset for hourly data


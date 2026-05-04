# monthglm returns a monthglm object whose coefficients are stable

    Code
      coef(m$glm)
    Output
      (Intercept)   monthsFeb   monthsMar   monthsApr   monthsMay   monthsJun 
       5.99789372 -0.10521225 -0.19250588 -0.24064839 -0.29685065 -0.33273796 
        monthsJul   monthsAug   monthsSep   monthsOct   monthsNov   monthsDec 
      -0.35644898 -0.35136373 -0.35192107 -0.30573229 -0.23639193 -0.07406741 

# monthglm rejects refmonth outside 1:12

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 0)
    Condition
      Error in `monthglm()`:
      ! Reference month must be between 1 and 12

---

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 13)
    Condition
      Error in `monthglm()`:
      ! Reference month must be between 1 and 12

# monthglm fails when invalid family used

    Code
      monthglm(cvd ~ 1, data = CVD, family = fish(), refmonth = 1)
    Condition
      Error in `fish()`:
      ! could not find function "fish"

# monthglm fails when invalid monthvariable used

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 1, monthvar = "year")
    Condition
      Error in `relevel.factor()`:
      ! 'ref' must be an existing level

# monthglm offsets work and fail appropriately

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 1, offsetpop = expression(
        pop))
    Output
      
      Call:  glm(formula = f, family = family, data = data, offset = off)
      
      Coefficients:
      (Intercept)    monthsFeb    monthsMar    monthsApr    monthsMay    monthsJun  
         -5.49672     -0.19684     -0.19251     -0.27344     -0.29685     -0.36553  
        monthsJul    monthsAug    monthsSep    monthsOct    monthsNov    monthsDec  
         -0.35645     -0.35136     -0.38471     -0.30573     -0.26918     -0.07407  
      
      Degrees of Freedom: 167 Total (i.e. Null);  156 Residual
      Null Deviance:	    4348 
      Residual Deviance: 1078 	AIC: 2623

---

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 1, offsetpop = expression(
        bananas))
    Condition
      Error:
      ! object 'bananas' not found

---

    Code
      monthglm(cvd ~ 1, data = CVD, family = poisson(), refmonth = 1, offsetmonth = "January")
    Condition
      Error in `monthglm()`:
      ! `offsetmonth` must be logical, we see type: character


# cosinor produces the right output type

    Code
      names(res)
    Output
      [1] "call"          "glm"           "fitted.plus"   "fitted.values"
      [5] "residuals"     "date"         

---

    Code
      summary(res$residuals)
    Output
          Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
      -5.66254 -2.14184 -0.42351 -0.04348  1.40717 11.13705 

---

    Code
      summary(res$fitted.values)
    Output
         Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
         1169    1231    1366    1374    1515    1595 

---

    Code
      summary(res$fitted.plus)
    Output
         Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
         1190    1217    1368    1373    1512    1625 

---

    Code
      res$glm
    Output
      
      Call:  glm(formula = f, family = family, data = data, offset = offset)
      
      Coefficients:
      (Intercept)         cosw         sinw  
          7.21933      0.15552      0.02237  
      
      Degrees of Freedom: 167 Total (i.e. Null);  165 Residual
      Null Deviance:	    4330 
      Residual Deviance: 1496 	AIC: 3023


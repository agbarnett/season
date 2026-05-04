# overall structure of the casecross model is consistent

    Code
      model1
    Output
      Call:
      survival::coxph(formula = finalformula, data = finished, weights = outcome, 
          method = c("breslow"))
      
                  coef exp(coef)  se(coef)      z      p
      o3mean -0.002883  0.997122  0.001129 -2.553 0.0107
      tmpd    0.001461  1.001462  0.001981  0.738 0.4607
      Mon     0.042733  1.043660  0.028943  1.476 0.1398
      Tue     0.057911  1.059620  0.028773  2.013 0.0441
      Wed    -0.010008  0.990042  0.029172 -0.343 0.7315
      Thu    -0.016790  0.983350  0.029456 -0.570 0.5687
      Fri     0.027248  1.027623  0.029173  0.934 0.3503
      Sat     0.001856  1.001858  0.028900  0.064 0.9488
      
      Likelihood ratio test=20.37  on 8 df, p=0.009011
      n= 8815, number of events= 365 

---

    Code
      names(model1)
    Output
      [1] "call"         "c.model"      "ncases"       "ncasedays"    "ncontroldays"

---

    Code
      model1$c.model
    Output
      Call:
      survival::coxph(formula = finalformula, data = finished, weights = outcome, 
          method = c("breslow"))
      
                  coef exp(coef)  se(coef)      z      p
      o3mean -0.002883  0.997122  0.001129 -2.553 0.0107
      tmpd    0.001461  1.001462  0.001981  0.738 0.4607
      Mon     0.042733  1.043660  0.028943  1.476 0.1398
      Tue     0.057911  1.059620  0.028773  2.013 0.0441
      Wed    -0.010008  0.990042  0.029172 -0.343 0.7315
      Thu    -0.016790  0.983350  0.029456 -0.570 0.5687
      Fri     0.027248  1.027623  0.029173  0.934 0.3503
      Sat     0.001856  1.001858  0.028900  0.064 0.9488
      
      Likelihood ratio test=20.37  on 8 df, p=0.009011
      n= 8815, number of events= 365 


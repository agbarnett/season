# overall structure of the casecross model is consistent

    Code
      model1
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
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
      [1] "call"           "cox_model"      "n_cases"        "n_case_days"   
      [5] "n_control_days"

---

    Code
      model1$cox_model
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
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

# 'matchconf' argument of `casecross()` works as expected

    Code
      model3
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
                  coef exp(coef)  se(coef)      z        p
      o3mean -0.003239  0.996767  0.001318 -2.456  0.01403
      Mon     0.182058  1.199684  0.035778  5.089 3.61e-07
      Tue     0.144181  1.155093  0.035633  4.046 5.20e-05
      Wed     0.099443  1.104556  0.035549  2.797  0.00515
      Thu     0.088518  1.092554  0.034595  2.559  0.01051
      Fri     0.108107  1.114167  0.034373  3.145  0.00166
      Sat     0.023660  1.023942  0.035252  0.671  0.50211
      
      Likelihood ratio test=51.19  on 7 df, p=8.436e-09
      n= 1915, number of events= 365 

---

    Code
      names(model3)
    Output
      [1] "call"           "cox_model"      "n_cases"        "n_case_days"   
      [5] "n_control_days"

---

    Code
      model3$cox_model
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
                  coef exp(coef)  se(coef)      z        p
      o3mean -0.003239  0.996767  0.001318 -2.456  0.01403
      Mon     0.182058  1.199684  0.035778  5.089 3.61e-07
      Tue     0.144181  1.155093  0.035633  4.046 5.20e-05
      Wed     0.099443  1.104556  0.035549  2.797  0.00515
      Thu     0.088518  1.092554  0.034595  2.559  0.01051
      Fri     0.108107  1.114167  0.034373  3.145  0.00166
      Sat     0.023660  1.023942  0.035252  0.671  0.50211
      
      Likelihood ratio test=51.19  on 7 df, p=8.436e-09
      n= 1915, number of events= 365 

# 'stratamonth' argument of `casecross()` works as expected

    Code
      model4
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
                  coef exp(coef)  se(coef)      z      p
      o3mean -0.002091  0.997911  0.001094 -1.911 0.0560
      Mon     0.049023  1.050245  0.028894  1.697 0.0898
      Tue     0.071367  1.073975  0.028736  2.484 0.0130
      Wed     0.014439  1.014544  0.029206  0.494 0.6210
      Thu     0.008720  1.008758  0.029253  0.298 0.7656
      Fri     0.041023  1.041876  0.029177  1.406 0.1597
      Sat     0.002191  1.002193  0.028903  0.076 0.9396
      
      Likelihood ratio test=16.94  on 7 df, p=0.0178
      n= 9723, number of events= 365 

---

    Code
      names(model4)
    Output
      [1] "call"           "cox_model"      "n_cases"        "n_case_days"   
      [5] "n_control_days"

---

    Code
      model4$cox_model
    Output
      Call:
      survival::coxph(formula = form_final, data = finished, weights = outcome, 
          method = "breslow")
      
                  coef exp(coef)  se(coef)      z      p
      o3mean -0.002091  0.997911  0.001094 -1.911 0.0560
      Mon     0.049023  1.050245  0.028894  1.697 0.0898
      Tue     0.071367  1.073975  0.028736  2.484 0.0130
      Wed     0.014439  1.014544  0.029206  0.494 0.6210
      Thu     0.008720  1.008758  0.029253  0.298 0.7656
      Fri     0.041023  1.041876  0.029177  1.406 0.1597
      Sat     0.002191  1.002193  0.028903  0.076 0.9396
      
      Likelihood ratio test=16.94  on 7 df, p=0.0178
      n= 9723, number of events= 365 


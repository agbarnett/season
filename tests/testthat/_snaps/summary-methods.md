# summary.Cosinor builds the documented summary.Cosinor object

    Code
      s
    Output
      Cosinor test:
      Number of observations = 168 
      Amplitude = 232.34 (absolute scale) 
      Phase: Month = 1.3 
      Low point: Month = 7.3 
      Significant seasonality based on adjusted significance level of 0.025  =  TRUE 
      
      Regression coefficients:
                    Estimate  Std..Error     z.value     Pr...z..
      (Intercept) 7.21933179 0.002093436 3448.557005 0.000000e+00
      cosw        0.15552367 0.002955997   52.612939 0.000000e+00
      sinw        0.02237303 0.002949022    7.586594 3.284251e-14

# summary.Cosinor errors on non-Cosinor input

    Code
      summary.Cosinor(list(a = 1))
    Condition
      Error in `summary.Cosinor()`:
      ! Object must be of class 'Cosinor'

# summary.monthglm builds the documented summary.monthglm object

    Code
      round(s$month.ests, 4)
    Output
                  mean  lower  upper   zvalue pvalue
      monthsFeb 0.9001 0.8836 0.9170 -11.0934      0
      monthsMar 0.8249 0.8097 0.8403 -20.3216      0
      monthsApr 0.7861 0.7713 0.8012 -24.8366      0
      monthsMay 0.7432 0.7291 0.7575 -30.4330      0
      monthsJun 0.7170 0.7031 0.7311 -33.4371      0
      monthsJul 0.7002 0.6867 0.7139 -35.9158      0
      monthsAug 0.7037 0.6902 0.7175 -35.4564      0
      monthsSep 0.7033 0.6897 0.7173 -35.1644      0
      monthsOct 0.7366 0.7226 0.7508 -31.2636      0
      monthsNov 0.7895 0.7746 0.8046 -24.4267      0
      monthsDec 0.9286 0.9121 0.9455  -8.0697      0

# summary.monthglm errors on non-monthglm input

    Code
      summary.monthglm(list(a = 1))
    Condition
      Error in `summary.monthglm()`:
      ! Object must be of class 'monthglm'

# summary.nsCosinor errors on non-nsCosinor input

    Code
      summary.nsCosinor(list(a = 1))
    Condition
      Error in `summary.nsCosinor()`:
      ! Object must be of class 'nsCosinor'

# summary.casecross prints a structured report

    Code
      summary(m)
    Output
      Time-stratified case-crossover with a stratum length of 28 days
      Total number of cases 17502 
      Number of case days with available control days 364 
      Average number of control days per case day 23.2 
      
      Parameter Estimates:
                     coef exp(coef)    se(coef)           z   Pr(>|z|)
      o3mean -0.002882613 0.9971215 0.001128975 -2.55330077 0.01067073
      tmpd    0.001461400 1.0014625 0.001981047  0.73769030 0.46070267
      Mon     0.042733425 1.0436596 0.028942815  1.47647783 0.13981566
      Tue     0.057910712 1.0596204 0.028772745  2.01269332 0.04414690
      Wed    -0.010008025 0.9900419 0.029171937 -0.34307029 0.73154558
      Thu    -0.016790296 0.9833499 0.029455877 -0.57001513 0.56866744
      Fri     0.027247952 1.0276226 0.029173235  0.93400517 0.35030123
      Sat     0.001855841 1.0018576 0.028900116  0.06421568 0.94879849

# summary.casecross errors on non-casecross input

    Code
      summary.casecross(list(a = 1))
    Condition
      Error in `summary.casecross()`:
      ! Object must be of class 'casecross'


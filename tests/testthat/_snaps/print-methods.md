# print.Cosinor prints the underlying GLM

    Code
      print(m)
    Output
      
      Call:  glm(formula = f, family = family, data = data, offset = offset)
      
      Coefficients:
      (Intercept)         cosw         sinw  
          7.21933      0.15552      0.02237  
      
      Degrees of Freedom: 167 Total (i.e. Null);  165 Residual
      Null Deviance:	    4330 
      Residual Deviance: 1496 	AIC: 3023

# print.Cosinor errors on non-Cosinor input

    Code
      print.Cosinor(list(a = 1))
    Condition
      Error in `print.Cosinor()`:
      ! Object must be of class 'Cosinor'

# print.monthglm prints the underlying GLM

    Code
      print(m)
    Output
      
      Call:  glm(formula = f, family = family, data = data, offset = off)
      
      Coefficients:
      (Intercept)    monthsFeb    monthsMar    monthsApr    monthsMay    monthsJun  
          7.45528     -0.10521     -0.19251     -0.24065     -0.29685     -0.33274  
        monthsJul    monthsAug    monthsSep    monthsOct    monthsNov    monthsDec  
         -0.35645     -0.35136     -0.35192     -0.30573     -0.23639     -0.07407  
      
      Degrees of Freedom: 167 Total (i.e. Null);  156 Residual
      Null Deviance:	    4330 
      Residual Deviance: 1066 	AIC: 2611

# print.monthglm errors on non-monthglm input

    Code
      print.monthglm(list(a = 1))
    Condition
      Error in `print.monthglm()`:
      ! Object must be of class 'monthglm'

# print.Monthmean prints a named 12-row table

    Code
      print(mm)
    Output
           Month  Mean
         January 402.6
        February 366.1
           March 332.1
           April 316.5
             May 299.2
            June 288.6
            July 281.9
          August 283.3
       September 283.1
         October 296.5
        November 317.8
        December 373.8

# print.Monthmean errors on non-Monthmean input

    Code
      print.Monthmean(list(a = 1))
    Condition
      Error in `print.Monthmean()`:
      ! Object must be of class 'Monthmean'

# print.nonlintest prints the test statistics block

    Code
      print(res)
    Output
      Largest and smallest co-ordinates of the third-order moment outside the test limits
      Largest difference is zero
      Smallest difference is zero
      
      Bootstrap test of non-linearity using the third-order moment
      Statistics for areas outside test limits:
      observed     obs/SD     median-null    95%-null    p-value
      0 0 0.004686457 0.2214431 0.6 

# print.nonlintest errors on non-nonlintest input

    Code
      print.nonlintest(list(a = 1))
    Condition
      Error in `print.nonlintest()`:
      ! Object must be of class 'nonlintest'

# print.nsCosinor prints model overview and residual stats

    Code
      print(m)
    Output
      Non-stationary cosinor
      
      Call:
      nscosinor(data = head(CVD, 60), response = "adj", cycles = 12, 
          niters = 60, burnin = 30, tau = c(10, 50), div = 1000, lambda = 1/12, 
          monthly = TRUE, alpha = 0.05)
      
      Number of MCMC samples = 31
      
      Length of time series = 60
      
      Residual statistics
          Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
      -268.225  -90.345    4.674    8.034   72.760  443.182 

# print.nsCosinor errors on non-nsCosinor input

    Code
      print.nsCosinor(list(a = 1))
    Condition
      Error in `print.nsCosinor()`:
      ! Object must be of class 'nsCosinor'

# print.casecross prints the underlying coxph fit

    Code
      print(m)
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

# print.casecross errors on non-casecross input

    Code
      print.casecross(list(a = 1))
    Condition
      Error in `print.casecross()`:
      ! Object must be of class 'casecross'

# print.casecross errors when c.model is not a coxph fit

    Code
      print(bad)
    Condition
      Error in `print.casecross()`:
      ! Conditional logistic regression model object 'c.model' must be of class 'coxph'

# print.summary.Cosinor prints the cosinor test report

    Code
      print(summary(m))
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

# print.summary.Cosinor errors on non-summary.Cosinor input

    Code
      print.summary.Cosinor(list(a = 1))
    Condition
      Error in `print.summary.Cosinor()`:
      ! Object must be of class 'summary.Cosinor'

# print.summary.monthglm prints the month-effect table

    Code
      print(summary(m))
    Output
      Number of observations = 168 
      Rate ratios 
                     mean     lower     upper     zvalue        pvalue
      monthsFeb 0.9001334 0.8835557 0.9170223 -11.093389  1.350710e-28
      monthsMar 0.8248895 0.8097153 0.8403480 -20.321628  8.278563e-92
      monthsApr 0.7861180 0.7713300 0.8011895 -24.836563 3.612571e-136
      monthsMay 0.7431550 0.7290823 0.7574993 -30.432988 2.011735e-203
      monthsJun 0.7169580 0.7031100 0.7310788 -33.437125 3.960379e-245
      monthsJul 0.7001582 0.6866705 0.7139109 -35.915811 1.730663e-282
      monthsAug 0.7037277 0.6901913 0.7175297 -35.456352 2.315335e-275
      monthsSep 0.7033356 0.6896741 0.7172678 -35.164379 7.008762e-271
      monthsOct 0.7365838 0.7226003 0.7508379 -31.263630 1.457403e-214
      monthsNov 0.7894712 0.7746378 0.8045886 -24.426747 8.891612e-132
      monthsDec 0.9286091 0.9120533 0.9454655  -8.069682  7.048164e-16

# print.summary.monthglm uses 'Odds ratios' for binomial

    Code
      print(summary(m))
    Output
      Number of observations = 168 
      Odds ratios 
                     mean     lower     upper    zvalue        pvalue
      monthsFeb 0.7956431 0.7741639 0.8177182 -16.37211  3.025234e-60
      monthsMar 0.6704909 0.6527854 0.6886767 -29.27641 2.071210e-188
      monthsApr 0.6135494 0.5971851 0.6303620 -35.41638 9.554173e-275
      monthsMay 0.5555216 0.5407776 0.5706676 -42.83210  0.000000e+00
      monthsJun 0.5224839 0.5084660 0.5368884 -46.78390  0.000000e+00
      monthsJul 0.5021564 0.4887683 0.5159112 -49.96136  0.000000e+00
      monthsAug 0.5064214 0.4929254 0.5202870 -49.36932  0.000000e+00
      monthsSep 0.5059515 0.4923557 0.5199227 -49.02295  0.000000e+00
      monthsOct 0.5470756 0.5325470 0.5620007 -43.92146  0.000000e+00
      monthsNov 0.6182944 0.6018069 0.6352336 -34.86498 2.525075e-266
      monthsDec 0.8489118 0.8264999 0.8719315 -11.99911  3.591556e-33

# print.summary.nscosinor prints amplitude and phase blocks

    Code
      print.summary.nscosinor(summary(m))
    Output
      Statistics for non-stationary cosinor based on MCMC chains
      Number of MCMC samples = 31
      
      Standard deviations
      Residual, mean=122.9904, 95% CI [106.5995, 143.7953]
      Cycle=12
      Season, mean=0.2085109, 95% CI [0.1733934, 0.2707067]
      
      Phase and amplitude
      Cycle=12
      Amplitude, mean=209.322, 95% CI [169.9456, 242.3682]
      Phase (radians), mean=0.7311538, 95% CI [0.5130923, 0.9835682]

# print.summary.nscosinor errors on non-summary.nsCosinor input

    Code
      print.summary.nscosinor(list(a = 1))
    Condition
      Error in `print.summary.nscosinor()`:
      ! Object must be of class 'summary.nsCosinor'

# print.summary.nscosinor handles multiple seasonal cycles

    Code
      print.summary.nscosinor(summary(m))
    Output
      Statistics for non-stationary cosinor based on MCMC chains
      Number of MCMC samples = 31
      
      Standard deviations
      Residual, mean=102.8497, 95% CI [81.49613, 122.9949]
      Cycle=6
      Season, mean=0.1359504, 95% CI [0.08590661, 0.2021593]
      Cycle=12
      Season, mean=0.1859972, 95% CI [0.1413316, 0.262306]
      
      Phase and amplitude
      Cycle=6
      Amplitude, mean=96.1238, 95% CI [68.79918, 136.6394]
      Phase (radians), mean=1.190498, 95% CI [0.7148488, 1.628128]
      Cycle=12
      Amplitude, mean=215.3999, 95% CI [169.8538, 245.6512]
      Phase (radians), mean=0.7427375, 95% CI [0.5959092, 0.9045558]


# nscosinor rejects malformed inputs

    Code
      nscosinor(data = data.frame(adj = 1:24), response = "adj", cycles = 12, tau = c(
        10, 50))
    Condition
      Error:
      ! Data must contain a variable called 'year'

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = 10)
    Condition
      Error:
      ! 'tau' must be a vector of size 'cycle' + 1
      i.e., a smoothing parameter (tau) for each cycle, plus one for trend
      We see:
      length tau:1
      length cycle:1

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 0, tau = c(10, 50))
    Condition
      Error:
      ! cycles must be > 0
      There are 1 values below 0

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = c(10, 50), niters = 10,
      burnin = 100)
    Condition
      Error:
      ! Number of iterations must be greater than burn-in
      We see:
      burnin: 100
      niters: 100

---

    Code
      nscosinor(data = cvd_na, response = "adj", cycles = 12, tau = c(10, 50))
    Condition
      Error:
      ! There must be no missing data in the dependent variable
      We see: 1 missing value(s)

# nscosinor handles two seasonal cycles

    Code
      summary(res$season)
    Output
            mean               lower              upper             mean          
       Min.   :-103.1928   Min.   :-170.938   Min.   :-69.31   Min.   :-230.1947  
       1st Qu.: -59.4808   1st Qu.:-112.211   1st Qu.:-21.28   1st Qu.:-146.6792  
       Median :  -1.5918   Median : -54.864   Median : 26.23   Median :  -0.3445  
       Mean   :  -0.7849   Mean   : -54.217   Mean   : 33.04   Mean   :   0.7375  
       3rd Qu.:  58.9063   3rd Qu.:  -5.327   3rd Qu.: 90.37   3rd Qu.: 147.6054  
       Max.   : 102.6375   Max.   :  64.362   Max.   :143.71   Max.   : 241.2622  
           lower             upper        
       Min.   :-283.29   Min.   :-189.78  
       1st Qu.:-208.97   1st Qu.:-109.06  
       Median : -59.27   Median :  49.39  
       Mean   : -67.58   Mean   :  45.22  
       3rd Qu.:  71.57   3rd Qu.: 184.92  
       Max.   : 159.39   Max.   : 285.22  


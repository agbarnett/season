# monthmean reproduces the published Fig 2.11 CVD rates

    Code
      mm
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

# monthmean errors when required variables are missing

    Code
      monthmean()
    Condition
      Error in `monthmean()`:
      ! argument "data" is missing, with no default

---

    Code
      monthmean(data = NULL, resp = "x")
    Condition
      Error in `monthmean()`:
      ! `data` must contain a variable called `year`.

---

    Code
      monthmean(data = CVD)
    Output
      Total number of days =  5114 
    Condition
      Error in `monthmean()`:
      ! argument "resp" is missing, with no default

---

    Code
      monthmean(data = data.frame(month = 1:12, x = 1:12), resp = "x")
    Condition
      Error in `monthmean()`:
      ! `data` must contain a variable called `year`.

---

    Code
      monthmean(data = data.frame(year = rep(2000, 12), x = 1:12), resp = "x")
    Condition
      Error in `monthmean()`:
      ! `data` must contain a variable called `month`.

# monthmean works

    Code
      monthmean(data = data.frame(month = 1:12, x = 1:12, year = rep(1999, 12)),
      resp = "x")
    Output
      Total number of days =  365 
           Month Mean
         January    1
        February    2
           March    3
           April    4
             May    5
            June    6
            July    7
          August    8
       September    9
         October   10
        November   11
        December   12


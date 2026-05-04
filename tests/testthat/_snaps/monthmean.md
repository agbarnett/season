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
      monthmean(data = NULL, resp = "x")
    Condition
      Error in `monthmean()`:
      ! must have an input data set (data)

---

    Code
      monthmean(data = CVD, resp = NULL)
    Condition
      Error in `monthmean()`:
      ! must have an input variable (resp)

---

    Code
      monthmean(data = data.frame(month = 1:12, x = 1:12), resp = "x")
    Condition
      Error in `monthmean()`:
      ! data set must contain a variable with the 4 digit year called 'year'

---

    Code
      monthmean(data = data.frame(year = rep(2000, 12), x = 1:12), resp = "x")
    Condition
      Error in `monthmean()`:
      ! data set must contain a variable with the numeric month called 'month'


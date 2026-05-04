# nscosinor rejects malformed inputs

    Code
      nscosinor(data = data.frame(adj = 1:24), response = "adj", cycles = 12, tau = c(
        10, 50))
    Condition
      Error in `nscosinor()`:
      ! Data needs to contain numeric year and month variables

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = 10)
    Condition
      Error in `nscosinor()`:
      ! Need to give a smoothing parameter (tau) for each cycle, plus one for the trend

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 0, tau = c(10, 50))
    Condition
      Error in `nscosinor()`:
      ! Cycles cannot be <=0

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = c(10, 50), niters = 10,
      burnin = 100)
    Condition
      Error in `nscosinor()`:
      ! Number of iterations must be greater than burn-in

---

    Code
      nscosinor(data = cvd_na, response = "adj", cycles = 12, tau = c(10, 50))
    Condition
      Error in `nscosinor()`:
      ! Missing data in the dependent variable not allowed


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


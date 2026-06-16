# nscosinor rejects malformed inputs

    Code
      nscosinor(data = data.frame(adj = 1:24), response = "adj", cycles = 12, tau = c(
        10, 50))
    Condition
      Error in `nscosinor()`:
      ! `data` must contain a variable called `year`.

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = 10)
    Condition
      Error in `nscosinor()`:
      ! `tau` must have length 2.
      i One smoothing parameter per cycle, plus one for trend.
      x We see length(`tau`) = 1, length(`cycles`) = 1.

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 0, tau = c(10, 50))
    Condition
      Error in `nscosinor()`:
      ! `cycles` must be greater than "0".
      x We see 1 value <= 0.

---

    Code
      nscosinor(data = CVD, response = "adj", cycles = 12, tau = c(10, 50), niters = 10,
      burnin = 100)
    Condition
      Error in `nscosinor()`:
      ! `niters` must be greater than `burnin`.
      x We see `burnin` = 100, `niters` = 10.

---

    Code
      nscosinor(data = cvd_na, response = "adj", cycles = 12, tau = c(10, 50))
    Condition
      Error in `nscosinor()`:
      ! `resp` must not contain missing values.
      x We see 1 missing value.

# nscosinor fails when year/month columns don't exist

    Code
      nscosinor(data = head(CVD, 60), response = "adj", cycles = 12, tau = c(10, 50),
      niters = 60, burnin = 30, div = 1000, year_var = "yr", month_var = "mn")
    Condition
      Error in `nscosinor()`:
      ! `data` must contain a variable called `yr`.


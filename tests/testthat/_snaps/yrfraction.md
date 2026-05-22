# yrfraction(type='daily') refuses non-Date input

    Code
      yrfraction("2020-01-01", type = "daily")
    Condition
      Error in `yrfrac_daily()`:
      ! `date` must be in <Date> format.
      i See `?Dates()`.

# yrfraction(type='weekly') refuses values outside 1:53

    Code
      yrfraction(c(0, 1, 2), type = "weekly")
    Condition
      Error in `yrfrac_weekly()`:
      ! `date` must be an integer in "1:53" for "weekly" data.
      i We see a range of 0 to 2.

---

    Code
      yrfraction(c(50, 60), type = "weekly")
    Condition
      Error in `yrfrac_weekly()`:
      ! `date` must be an integer in "1:53" for "weekly" data.
      i We see a range of 50 to 60.

# yrfraction(type='monthly') refuses values outside 1:12

    Code
      yrfraction(c(0, 6), type = "monthly")
    Condition
      Error in `yrfrac_monthly()`:
      ! `date` must be an integer in "1:12" for "monthly" data.
      i We see a range of 0 to 6.

---

    Code
      yrfraction(c(6, 13), type = "monthly")
    Condition
      Error in `yrfrac_monthly()`:
      ! `date` must be an integer in "1:12" for "monthly" data.
      i We see a range of 6 to 13.

# yrfraction fails when type is not of defined set

    Code
      yrfraction(c(1, 2, 3), type = "minutes")
    Condition
      Error in `yrfraction()`:
      ! `type` must be one of "daily", "weekly", or "monthly", not "minutes".


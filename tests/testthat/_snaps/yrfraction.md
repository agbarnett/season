# yrfraction(type='daily') refuses non-Date input

    Code
      yrfraction("2020-01-01", type = "daily")
    Condition
      Error in `yrfrac_daily()`:
      ! Date variable for annual data must be in date format, see ?Dates

# yrfraction(type='weekly') refuses values outside 1:53

    Code
      yrfraction(c(0, 1, 2), type = "weekly")
    Condition
      Error in `yrfrac_weekly()`:
      ! Date variable for weekly data must be month integer (1 to 53)

---

    Code
      yrfraction(c(50, 60), type = "weekly")
    Condition
      Error in `yrfrac_weekly()`:
      ! Date variable for weekly data must be month integer (1 to 53)

# yrfraction(type='monthly') refuses values outside 1:12

    Code
      yrfraction(c(0, 6), type = "monthly")
    Condition
      Error in `yrfrac_monthly()`:
      ! Date variable for monthly data must be month integer (1 to 12)

---

    Code
      yrfraction(c(6, 13), type = "monthly")
    Condition
      Error in `yrfrac_monthly()`:
      ! Date variable for monthly data must be month integer (1 to 12)

# yrfraction fails when type is not of defined set

    Code
      yrfraction(c(1, 2, 3), type = "minutes")
    Condition
      Error in `yrfraction()`:
      ! `type` must be one of "daily", "weekly", or "monthly", not "minutes".


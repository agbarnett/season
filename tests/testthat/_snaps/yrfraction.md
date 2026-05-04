# yrfraction(type='daily') refuses non-Date input

    Code
      yrfraction("2020-01-01", type = "daily")
    Condition
      Error in `yrfraction()`:
      ! Date variable for annual data must be in date format, see ?Dates

# yrfraction(type='weekly') refuses values outside 1:53

    Code
      yrfraction(c(0, 1, 2), type = "weekly")
    Condition
      Error in `yrfraction()`:
      ! Date variable for weekly data must be month integer (1 to 53)

---

    Code
      yrfraction(c(50, 60), type = "weekly")
    Condition
      Error in `yrfraction()`:
      ! Date variable for weekly data must be month integer (1 to 53)

# yrfraction(type='monthly') refuses values outside 1:12

    Code
      yrfraction(c(0, 6), type = "monthly")
    Condition
      Error in `yrfraction()`:
      ! Date variable for monthly data must be month integer (1 to 12)

---

    Code
      yrfraction(c(6, 13), type = "monthly")
    Condition
      Error in `yrfraction()`:
      ! Date variable for monthly data must be month integer (1 to 12)


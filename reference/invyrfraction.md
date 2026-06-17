# Inverts a fraction of the year or hour to a useful time scale.

Returns the day and month (for "daily") or fraction of the month (for
"monthly") given a fraction of the year. Assumes a year length of 365.25
days for "daily". When using "monthly" the 1st of January is 1, the 1st
of December is 12, and the 31st of December is 12.9. For "hourly" it
returns the fraction of the 24-hour clock starting from zero (midnight).

## Usage

``` r
invyrfraction(
  frac,
  type = c("daily", "monthly", "hourly", "weekly"),
  text = TRUE
)

invyrfraction_chr(frac, type = c("daily", "monthly", "hourly", "weekly"))

invyrfraction_num(frac, type = c("daily", "monthly", "hourly", "weekly"))
```

## Arguments

- frac:

  a vector of fractions of the year, all between 0 and 1.

- type:

  "daily" for dates, "monthly" for months, "hourly" for hours, "weekly"
  for weeks.

- text:

  add an explanatory text to the returned value (TRUE) or return a
  number (FALSE).

## Value

the date (day and month for "daily"), fractional month (for "monthly"),
or fraction of the 24-hour clock (for "hourly").

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r

invyrfraction(c(0, 0.5, 0.99), type = "hourly")
#> [1] "Hour = 0"    "Hour = 12"   "Hour = 23.8"
invyrfraction(c(0, 0.5, 0.99), type = "daily")
#> [1] "Month = January , day = 1"   "Month = July , day = 2"     
#> [3] "Month = December , day = 28"
invyrfraction(c(0, 0.5, 0.99), type = "weekly")
#> [1] "Week = 1"    "Week = 27"   "Week = 52.5"
invyrfraction(c(0, 0.5, 0.99), type = "monthly")
#> [1] "Month = 1"    "Month = 7"    "Month = 12.9"

# Also provide _chr and _num functions that mean you don't specify arg,
# `text = TRUE` or `text = FALSE`
invyrfraction_num(c(0, 0.5, 0.99), type = "weekly")
#> [1]  1.00 27.00 52.48
invyrfraction_chr(c(0, 0.5, 0.99), type = "weekly")
#> [1] "Week = 1"    "Week = 27"   "Week = 52.5"
```

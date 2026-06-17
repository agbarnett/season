# Fraction of the Year

Calculate the fraction of the year for a date variable (after accounting
for leap years) or for month.

## Usage

``` r
yrfraction(date, type = c("daily", "weekly", "monthly"))
```

## Arguments

- date:

  a date variable if type="daily", or an integer between 1 and 12 if
  type="monthly".

- type:

  One of "daily" (default) for dates, "monthly" for months, or "weekly"
  for weeks.

## Value

the fraction of the year.

## Details

Returns the fraction of the year in the range \[0,1).

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r

# create fractions for the start, middle and end of the year
date <- as.Date(c(0, 181, 364), origin = '1991-01-01')
# create fractions based on these dates
yrfraction(date)
#> [1] 0.0000000 0.4958904 0.9972603
yrfraction(1:12, type = 'monthly')
#>  [1] 0.00000000 0.08333333 0.16666667 0.25000000 0.33333333 0.41666667
#>  [7] 0.50000000 0.58333333 0.66666667 0.75000000 0.83333333 0.91666667
```

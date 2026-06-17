# Seasonal Residual Checks

Tests the residuals for any remaining seasonality.

## Usage

``` r
seasrescheck(res)
```

## Arguments

- res:

  residuals from some time series regression model.

## Value

four plots: 1. The histogram of the residuals; 2. A scatter plot against
residual order; 3. The autocovariance; 4. The cumulative periodogram
(see [`cpgram()`](https://rdrr.io/r/stats/cpgram.html)).

## Details

Plots: i) histogram of the residuals, ii) a scatter plot against
residual order, iii) the autocovariance, iv) the cumulative periodogram
(see [`cpgram()`](https://rdrr.io/r/stats/cpgram.html))

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# cardiovascular disease data
# (use an offset of the scaled number of days in a month)
model <- cosinor(
  cvd ~ 1,
  date = 'month',
  data = CVD,
  type = 'monthly',
  family = poisson(),
  offsetmonth = TRUE
  )
seasrescheck(resid(model))

# }
```

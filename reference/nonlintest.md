# Test of Non-linearity of a Time Series

A bootstrap test of non-linearity in a time series using the third-order
moment.

## Usage

``` r
nonlintest(data, n.lag, n.boot, alpha = 0.05)
```

## Arguments

- data:

  a vector of equally spaced numeric observations (time series).

- n.lag:

  the number of lags tested using the third-order moment, maximum =
  length of time series.

- n.boot:

  the number of bootstrap replications (suggested minimum of 100; 1000
  or more would be better).

- alpha:

  statistical significance level of test (default=0.05).

## Value

Returns an object of class "nonlintest" with the following parts:

- region: the region of the third order moment where the test exceeds
  the limits (up to `n.lag`).

- n.lag: the maximum lag tested using the third-order moment.

- stats: a list of statistics for the area outside the test limits:

  - outside: the total area outside of limits (summed over the whole
    third-order moment).

  - stan: the total area outside the limits divided by its standard
    deviation to give a standardised estimate.

  - median: the median area outside the test limits.

  - upper: the (1-`alpha`)th percentile of the area outside the limits.

  - pvalue: bootstrap p-value of the area outside the limits to test if
    the series is linear.

  - test: reject the null hypothesis that the series is linear
    (TRUE/FALSE).

## Details

The test uses `aaft` to create linear surrogates with the same
second-order properties, but no (third-order) non-linearity. The
third-order moments (`third`) of these linear surrogates and the actual
series are then compared from lags 0 up to `n.lag` (excluding the skew
at the co-ordinates (0,0)). The bootstrap test works on the overall area
outside the limits, and gives an indication of the overall
non-linearity. The plot using `region` shows those co-ordinates of the
third order moment that exceed the null hypothesis limits, and can be a
useful clue for guessing the type of non-linearity. For example, a large
value at the co-ordinates (0,1) might be caused by a bi-linear series
\\X_t=\alpha X\_{t-1}\varepsilon\_{t-1} +\varepsilon_t\\.

## References

Barnett AG & Wolff RC (2005) A Time-Domain Test for Some Types of
Nonlinearity, *IEEE Transactions on Signal Processing*, vol 53, pages
26–33 [doi:
10.1109/TSP.2004.838942](https://doi.org/%2010.1109/TSP.2004.838942) .

## See also

[`print.nonlintest()`](print.nonlintest.md)
[`plot.nonlintest()`](plot.nonlintest.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
if (FALSE) { # \dontrun{
test_res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 1000)
} # }
# }
```

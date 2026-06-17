# Walter and Elwood's Test of Seasonality

Tests for a seasonal pattern in Binomial data. A test of whether monthly
data has a sinusoidal seasonal pattern. The test has low power compared
with the [`cosinor()`](cosinor.md) test.

## Usage

``` r
wtest(cases, offset, data, alpha = 0.05)
```

## Arguments

- cases:

  variable name for cases ("successes").

- offset:

  variable name for at-risk population ("trials").

- data:

  data frame (optional).

- alpha:

  significance level (default=0.05).

## Value

a list with the following elements:

- test: test statistic.

- pvalue: p-value.

## References

Walter, S.D., Elwood, J.M. (1975) A test for seasonality of events with
a variable population at risk. *British Journal of Preventive and Social
Medicine* 29, 18–21.

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r

# tabulate the total number of births and the number of stillbirths
freqs <- table(stillbirth$month, stillbirth$stillborn)
data <- list()
data$trials <- as.numeric(freqs[, 1] + freqs[, 2])
data$success <- as.numeric(freqs[, 2])
# test for a seasonal pattern in stillbirth
test <- wtest(
  cases = 'success',
  offset = 'trials',
  data = data
)
```

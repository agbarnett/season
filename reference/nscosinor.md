# Non-stationary Cosinor

Decompose a time series using a non-stationary cosinor for the seasonal
pattern.

## Usage

``` r
nscosinor(
  data,
  response,
  cycles,
  niters = 1000,
  burnin = 500,
  tau,
  lambda = 1/12,
  div = 50,
  monthly = TRUE,
  alpha = 0.05,
  year_col = "year",
  month_col = "month"
)
```

## Arguments

- data:

  Data frame. Assumes no missing data. Year and month columns are by
  default assumed to be "year", and "month", respectively. These can be
  specified with arguments `year_col` and `month_col`.

- response:

  character. Response variable.

- cycles:

  vector of cycles in units of time, e.g., for a six and twelve month
  pattern `cycles=c(6,12)`.

- niters:

  total number of MCMC samples (default=1000).

- burnin:

  number of MCMC samples discarded as a burn-in (default=500).

- tau:

  vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for 1st
  seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc. Larger
  values of tau allow more change between observations and hence a
  greater potential flexibility in the trend and season.

- lambda:

  distance between observations (lambda=1/12 for monthly data, default).

- div:

  divisor at which MCMC sample progress is reported (default=50).

- monthly:

  TRUE for monthly data.

- alpha:

  Statistical significance level used by the confidence intervals.

- year_col:

  character. column referring to year. Default is "year".

- month_col:

  character. column referring to month. Default is "month".

## Value

Returns an object of class "nsCosinor" with the following parts:

- call: the original call to the nscosinor function.

- time: the year and month for monthly data.

- trend: mean trend and 95\\

- season: mean season(s) and 95\\

- oseason: overall season(s) and 95\\ be the same as `season` if there
  is only one seasonal cycle.

- fitted: fitted values and 95\\ season(s).

- residuals: residuals based on mean trend and season(s).

- n: the length of the series.

- chains: MCMC chains (of class mcmc) of variance estimates: standard
  error for overall noise (std.error), standard error for season(s)
  (std.season), phase(s) and amplitude(s).

- cycles: vector of cycles in units of time.

## Details

This model is designed to decompose an equally spaced time series into a
trend, season(s) and noise. A seasonal estimate is estimated as
\\s_t=A_t\cos(\omega_t-P_t)\\, where *t* is time, \\A_t\\ is the
non-stationary amplitude, \\P_t\\ is the non-stationary phase and
\\\omega_t\\ is the frequency.

A non-stationary seasonal pattern is one that changes over time, hence
this model gives potentially very flexible seasonal estimates.

The frequency of the seasonal estimate(s) are controlled by `cycle`. The
cycles should be specified in units of time. If the data is monthly,
then setting `lambda=1/12` and `cycles=12` will fit an annual seasonal
pattern. If the data is daily, then setting `lambda=` `1/365.25` and
`cycles=365.25` will fit an annual seasonal pattern. Specifying
`cycles=` `c(182.6,365.25)` will fit two seasonal patterns, one with a
twice-annual cycle, and one with an annual cycle.

The estimates are made using a forward and backward sweep of the Kalman
filter. Repeated estimates are made using Markov chain Monte Carlo
(MCMC). For this reason the model can take a long time to run. To give
stable estimates a reasonably long sample should be used (`niters`), and
the possibly poor initial estimates should be discarded (`burnin`).

## References

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

Barnett, A.G., Dobson, A.J. (2004) Estimating trends and seasonality in
coronary heart disease *Statistics in Medicine*. 23(22) 3505–23.

## See also

[`plot.nsCosinor()`](plot.nsCosinor.md)
[`summary.nsCosinor()`](summary.nsCosinor.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# model to fit an annual pattern to the monthly cardiovascular disease data
f <- c(12)
tau <- c(10,50)
if (FALSE) { # \dontrun{
  res12 <- nscosinor(
    data = CVD,
    response = 'adj',
    cycles = f,
    niters = 200,
    burnin = 50,
    tau = tau
    )
summary(res12)
# autoplot replaces plot method - plot(res12)
autoplot(res12)
} # }
# }
```

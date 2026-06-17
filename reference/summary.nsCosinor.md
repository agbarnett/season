# Summary for a Non-stationary Cosinor

The default summary method for a `nsCosinor` object produced by
[`nscosinor()`](nscosinor.md).

## Usage

``` r
# S3 method for class 'nsCosinor'
summary(object, ...)
```

## Arguments

- object:

  a `nsCosinor` object produced by [`nscosinor()`](nscosinor.md).

- ...:

  further arguments passed to or from other methods.

## Value

a list with the following elements:

- cycles: vector of cycles in units of time, e.g., for a six and twelve
  month pattern `cycles=c(6,12)`.

- niters: total number of MCMC samples.

- burnin: number of MCMC samples discarded as a burn-in.

- tau: vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for
  1st seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc.

- stats: summary statistics (mean and confidence interval) for the
  residual standard deviation, the standard deviation for each seasonal
  cycle, and the amplitude and phase for each cycle.

## Details

The amplitude describes the average height of each seasonal cycle, and
the phase describes the location of the peak. The results for the phase
are given in radians (0 to 2\\\pi\\), they can be transformed to the
time scale using the [`invyrfraction()`](invyrfraction.md) making sure
to first divide by 2\\\pi\\.

The larger the standard deviation for the seasonal cycles, the greater
the non-stationarity. This is because a larger standard deviation means
more change over time.

## See also

[`nscosinor()`](nscosinor.md) [`plot.nsCosinor()`](plot.nsCosinor.md)

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
    niters = 5000,
    burnin = 1000,
    tau = tau
    )
summary(res12)
plot(res12)
} # }
# }
```

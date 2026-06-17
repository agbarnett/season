# Plot the Results of a Non-stationary Cosinor

**\[deprecated\]** Soft-deprecated in favour of
[`autoplot.nsCosinor()`](autoplot.nsCosinor.md), which is the same
ggplot — just nudges the recommended idiom so users can `+ theme_bw()`
etc.

## Usage

``` r
# S3 method for class 'nsCosinor'
plot(x, ...)
```

## Arguments

- x:

  a `nsCosinor` object produced by [`nscosinor()`](nscosinor.md).

- ...:

  further arguments passed to or from other methods.

## Value

a plot of class `ggplot`.

## Details

The code produces the season(s) and trend estimates.

## See also

[`autoplot.nsCosinor()`](autoplot.nsCosinor.md),
[`nscosinor()`](nscosinor.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# model to fit an annual pattern to the monthly cardiovascular disease data
f <- 12
tau <- c(10,50)
if (FALSE) { # \dontrun{
  res12 <- nscosinor(
    data = CVD,
    response = 'adj',
    cycles = f,
    niters = 200,
    burnin = 100,
    tau = tau
    )
# Recommended:
autoplot(res12)
# Still works, but deprecated:
plot(res12)
} # }
# }
```

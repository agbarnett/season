# Print a summary of an [`nscosinor()`](nscosinor.md) object

Print a summary of an [`nscosinor()`](nscosinor.md) object

## Usage

``` r
# S3 method for class 'summary.nsCosinor'
print(x, ...)
```

## Arguments

- x:

  a `summary.nsCosinor` object produced by
  [`summary.nsCosinor()`](summary.nsCosinor.md).

- ...:

  further arguments passed to or from other methods.

## Value

summary - Statistics for non-stationary cosinor based on MCMC chains.

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
    burnin = 100,
    tau = tau
    )
summary(res12)
} # }
# }
```

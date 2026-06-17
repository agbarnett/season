# Print the Results of a Non-stationary Cosinor

The default print method for a `nsCosinor` object produced by
[`nscosinor()`](nscosinor.md).

## Usage

``` r
# S3 method for class 'nsCosinor'
print(x, ...)
```

## Arguments

- x:

  a `nsCosinor` object produced by [`nscosinor()`](nscosinor.md).

- ...:

  further arguments passed to or from other methods.

## Value

Prints out the model call, number of MCMC samples, sample size and
residual summary statistics.

## Details

Prints out the model call, number of MCMC samples, sample size and
residual summary statistics.

## See also

[`nscosinor()`](nscosinor.md)
[`summary.nsCosinor()`](summary.nsCosinor.md)

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
    niters = 250,
    burnin = 100,
    tau = tau
    )
res12
summary(res12)
} # }
# }
```

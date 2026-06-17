# Print the Results of the Non-linear Test

The default print method for a `nonlintest` object produced by
[`nonlintest()`](nonlintest.md).

## Usage

``` r
# S3 method for class 'nonlintest'
print(x, ...)
```

## Arguments

- x:

  a `nonlintest` object produced by [`nonlintest()`](nonlintest.md).

- ...:

  additional arguments to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html)

## Value

summary of Results of the Non-linear Test.

## See also

[`nonlintest()`](nonlintest.md)
[`plot.nonlintest()`](plot.nonlintest.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
if (FALSE) { # \dontrun{
test_res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 1000)
test_res
} # }
# }
```

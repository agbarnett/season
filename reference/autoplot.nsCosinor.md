# Plot the trend and seasonal estimates from [`nscosinor()`](nscosinor.md)

Returns a ggplot of the trend and seasonal components estimated by
[`nscosinor()`](nscosinor.md), faceted by component and with a ribbon
for the confidence interval.

## Usage

``` r
# S3 method for class 'nsCosinor'
autoplot(object, ...)
```

## Arguments

- object:

  an `nsCosinor` object produced by [`nscosinor()`](nscosinor.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot object faceted by trend / season(s).

## See also

[`nscosinor()`](nscosinor.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
if (FALSE) { # \dontrun{
res <- nscosinor(
  data = CVD, response = "adj", cycles = 12,
  niters = 200, burnin = 100, tau = c(10, 50)
)
autoplot(res)
autoplot(res) + ggplot2::theme_minimal()
} # }
# }
```

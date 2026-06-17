# Plot the fitted sinusoid from a [`cosinor()`](cosinor.md) model

Returns a ggplot of the fitted sinusoid. The y-axis is on the
probability scale for `logit` and `cloglog` link functions; the x-axis
switches between month, year, and hour depending on the `type` of the
model.

## Usage

``` r
# S3 method for class 'Cosinor'
autoplot(object, ...)
```

## Arguments

- object:

  a `Cosinor` object produced by [`cosinor()`](cosinor.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot object.

## See also

[`cosinor()`](cosinor.md), [`summary.Cosinor()`](summary.Cosinor.md),
[`seasrescheck()`](seasrescheck.md)

## Author

Nicholas Tierney

## Examples

``` r
res <- cosinor(
  cvd ~ 1,
  date = "month",
  data = CVD,
  type = "monthly",
  family = poisson(),
  offsetmonth = TRUE
)
autoplot(res)

autoplot(res) + ggplot2::theme_minimal()
```

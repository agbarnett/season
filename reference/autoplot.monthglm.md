# Plot the monthly estimates from [`monthglm()`](monthglm.md)

Returns a ggplot of the per-month coefficient estimates from a
[`monthglm()`](monthglm.md) fit, with a confidence interval per month
and (for Poisson/binomial families) a horizontal reference line at the
rate / odds ratio of 1.

## Usage

``` r
# S3 method for class 'monthglm'
autoplot(object, alpha = 0.05, ...)
```

## Arguments

- object:

  a `monthglm` object produced by [`monthglm()`](monthglm.md).

- alpha:

  statistical significance level for the confidence intervals (default
  0.05).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot object.

## See also

[`monthglm()`](monthglm.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
mmodel <- monthglm(
  formula = cvd ~ 1,
  data = CVD,
  family = poisson(),
  offsetpop = expression(pop / 100000),
  offsetmonth = TRUE,
  refmonth = 6
)
autoplot(mmodel)

autoplot(mmodel) + ggplot2::labs(x = "Month", y = "Rate ratio")

# }
```

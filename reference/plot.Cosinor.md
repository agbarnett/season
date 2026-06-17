# Plot the Results of a Cosinor

**\[deprecated\]** Soft-deprecated in favour of
[`autoplot.Cosinor()`](autoplot.Cosinor.md), which returns a ggplot
object you can extend with `+`. The base R plot below still works.

## Usage

``` r
# S3 method for class 'Cosinor'
plot(x, ...)
```

## Arguments

- x:

  a `Cosinor` object produced by [`cosinor()`](cosinor.md)

- ...:

  additional arguments passed to the sinusoid plot.

## Value

connected line plot of fitted sinusoid object produced by
[cosinor](cosinor.md).

## Details

The code produces the fitted sinusoid based on the intercept and
sinusoid. The y-axis is on the scale of probability if the link function
is "logit" or "cloglog". If the analysis was based on monthly data then
month is shown on the x-axis. If the analysis was based on daily data
then time is shown on the x-axis.

## See also

[`autoplot.Cosinor()`](autoplot.Cosinor.md), [`cosinor()`](cosinor.md),
[`summary.Cosinor()`](summary.Cosinor.md),
[`seasrescheck()`](seasrescheck.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
## cardiovascular disease data (offset based on number of days in...
## ...the month scaled to an average month length)
res <- cosinor(
  cvd ~ 1,
  date = 'month',
  data = CVD,
  type = 'monthly',
  family = poisson(),
  offsetmonth = TRUE
  )
# Recommended:
autoplot(res)

# Still works, but deprecated:
plot(res)
```

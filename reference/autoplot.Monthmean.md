# Plot the monthly mean estimates from [`monthmean()`](monthmean.md)

Returns a ggplot of the per-month means computed by
[`monthmean()`](monthmean.md).

## Usage

``` r
# S3 method for class 'Monthmean'
autoplot(object, ...)
```

## Arguments

- object:

  a `Monthmean` object produced by [`monthmean()`](monthmean.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot object.

## See also

[`monthmean()`](monthmean.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
mmean <- monthmean(
  data = CVD,
  resp = "cvd",
  offsetpop = expression(pop / 100000),
  adjmonth = "average"
)
#> Total number of days: 5114
autoplot(mmean)

autoplot(mmean) + ggplot2::theme_minimal()

# }
```

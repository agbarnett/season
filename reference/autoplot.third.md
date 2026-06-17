# Plot the third-order moment from [`third()`](third.md)

Produce a ggplot contour of the third-order moment over its
non-redundant region.

## Usage

``` r
# S3 method for class 'third'
autoplot(object, ...)
```

## Arguments

- object:

  a `"third"` object produced by [`third()`](third.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot contour plot.

## See also

[`third()`](third.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
t <- third(CVD$cvd, n.lag = 4)
#> Maximum at (including symmetries):
#>   0 0
#> Minimum at (including symmetries):
#>   0 -4 4 -4 0 4
autoplot(t)

# }
```

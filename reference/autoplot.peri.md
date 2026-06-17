# Plot the periodogram from [`peri()`](peri.md)

Produce a ggplot of the periodogram in both radians and cycles. The
returned ggplot can be extended with `+` (e.g.
`+ ggplot2::theme_minimal()`).

## Usage

``` r
# S3 method for class 'peri'
autoplot(object, ...)
```

## Arguments

- object:

  a `"peri"` object produced by [`peri()`](peri.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot object.

## See also

[`peri()`](peri.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
p <- peri(CVD$cvd)
autoplot(p)

autoplot(p) + ggplot2::theme_minimal()

# }
```

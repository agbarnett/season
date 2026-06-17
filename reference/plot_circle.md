# Circular plot of monthly values (ggplot2)

Circular plot of a monthly variable. This circular plot can be useful
for estimates of an annual seasonal pattern. Darker shades of grey
correspond to larger numbers. Pie chart where each segment is one month
and the fill is shaded to indicate the value (darker = larger). The
first value is assumed to be January. This circular plot can be useful
for estimates of an annual seasonal pattern. Darker shades of grey
correspond to larger numbers.

## Usage

``` r
plot_circle(months, dp = 1)
```

## Arguments

- months:

  a length-12 numeric vector of monthly values, January first.

- dp:

  decimal places for the per-month label, default 1.

## Value

a ggplot object.

## See also

[`plotCircle()`](plotCircle.md) (deprecated base R version)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
plot_circle(months = seq(1, 12, 1), dp = 0)

plot_circle(months = c(1, 3, 5, 7, 9, 11, 12, 10, 8, 6, 4, 2)) +
  ggplot2::labs(title = "Example monthly pattern")

# }
```

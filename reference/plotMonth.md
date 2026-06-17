# Plot Results by Month

Plots results by month. Assumes the data frame contains variables called
year and month.

## Usage

``` r
plotMonth(data, resp, panels = 12, ...)
```

## Arguments

- data:

  a data frame.

- resp:

  response variable to plot.

- panels:

  number of panels to use in plot (1 or 12). 12 gives one panel per
  month, 1 plots all the months in the same panel.

- ...:

  further arguments passed to or from other methods.

## Value

Facetted lineplot of response over time, one facet per month.

## Details

**\[deprecated\]** Soft-deprecated in favour of
[`plot_month()`](plot_month.md), which returns a ggplot object you can
extend with `+`. The existing function still works.

## References

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## See also

[`plot_month()`](plot_month.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
  # Recommended:
  plot_month(data = CVD, resp = "cvd", panels = 12)

  # Still works, but deprecated:
  plotMonth(data = CVD, resp = "cvd", panels = 12)
#> Warning: `plotMonth()` was deprecated in season 0.3.17.
#> ℹ Please use `plot_month()` instead.

# }
```

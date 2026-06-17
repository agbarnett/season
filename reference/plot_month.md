# Plot a response by month (ggplot2)

Plots results by month. Assumes the data frame contains variables called
year and month. Faceted or coloured line plot of a monthly response over
time. Assumes the data frame contains `year` and `month` columns.

## Usage

``` r
plot_month(data, resp, panels = 12)
```

## Arguments

- data:

  a data frame containing `year`, `month`, and the response.

- resp:

  character; name of the response variable.

- panels:

  1 (overlay) or 12 (one facet per month). Default 12.

## Value

a ggplot object.

## See also

[`plotMonth()`](plotMonth.md) (deprecated wrapper)

## Examples

``` r
# \donttest{
plot_month(data = CVD, resp = "cvd", panels = 12)

plot_month(data = CVD, resp = "cvd", panels = 1) +
  ggplot2::theme_minimal()

# }
```

# Plot of Monthly Mean Estimates

**\[deprecated\]** Soft-deprecated in favour of
[`autoplot.Monthmean()`](autoplot.Monthmean.md), which returns a ggplot
object you can extend with `+`. The base R plot below still works.

## Usage

``` r
# S3 method for class 'Monthmean'
plot(x, ...)
```

## Arguments

- x:

  a `Monthmean` object produced by [`monthmean()`](monthmean.md).

- ...:

  additional arguments passed to the plot.

## Value

Connected dot plot of estimated monthly means.

## See also

[`autoplot.Monthmean()`](autoplot.Monthmean.md),
[`monthmean()`](monthmean.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
mmean <- monthmean(
  data = CVD,
  resp = 'cvd',
  offsetpop = expression(pop / 100000),
  adjmonth = 'average'
)
#> Total number of days: 5114
mmean
#>      Month  Mean
#>    January 402.6
#>   February 366.1
#>      March 332.1
#>      April 316.5
#>        May 299.2
#>       June 288.6
#>       July 281.9
#>     August 283.3
#>  September 283.1
#>    October 296.5
#>   November 317.8
#>   December 373.8
# Recommended:
autoplot(mmean)

# Still works, but deprecated:
plot(mmean)

# }
```

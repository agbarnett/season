# Print the Results from Monthmean

Print the monthly mean estimates from a `Monthmean` object produced by
[`monthmean()`](monthmean.md).

## Usage

``` r
# S3 method for class 'Monthmean'
print(x, digits = 1, ...)
```

## Arguments

- x:

  a `Monthmean` object produced by [`monthmean()`](monthmean.md).

- digits:

  minimal number of significant digits, see
  [`print.default()`](https://rdrr.io/r/base/print.default.html).

- ...:

  additional arguments passed to
  [`print()`](https://rdrr.io/r/base/print.html).

## Value

a table of values of Month and means

## See also

`monthmean`

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
# }
```

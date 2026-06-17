# Tidy a casecross object

This implements the tidy method for
[`broom::tidy.coxph()`](https://broom.tidymodels.org/reference/tidy.coxph.html).

## Usage

``` r
# S3 method for class 'casecross'
tidy(x, exponentiate, conf.int, conf.level, ...)
```

## Arguments

- x:

  A `casecross` object returned from
  [`survival::coxph()`](https://rdrr.io/pkg/survival/man/coxph.html).

- exponentiate:

  Logical indicating whether or not to exponentiate the coefficient
  estimates. This is typical for logistic and multinomial regressions,
  but a bad idea if there is no log or logit link. Defaults to FALSE.

- conf.int:

  Logical indicating whether or not to include a confidence interval in
  the tidied output. Defaults to FALSE.

- conf.level:

  The confidence level to use for the confidence interval if conf.int =
  TRUE. Must be strictly greater than 0 and less than 1. Defaults to
  0.95, which corresponds to a 95 percent confidence interval.

- ...:

  For [`tidy()`](https://generics.r-lib.org/reference/tidy.html),
  additional arguments passed to `summary(x, ...)`. Otherwise ignored.

## Examples

``` r
# subset for example
CVDdaily <- subset(CVDdaily, date <= as.Date('1987-12-31'))
# Effect of ozone on CVD death
model1 <- casecross(
  cvd ~ o3mean + tmpd + Mon + Tue + Wed + Thu + Fri + Sat,
  data = CVDdaily
)
summary(model1)
#> Time-stratified case-crossover with a stratum length of 28 days
#> Total number of cases 17502 
#> Number of case days with available control days 364 
#> Average number of control days per case day 23.2 
#> 
#> Parameter Estimates:
#>                coef exp(coef)    se(coef)           z   Pr(>|z|)
#> o3mean -0.002882613 0.9971215 0.001128975 -2.55330077 0.01067073
#> tmpd    0.001461400 1.0014625 0.001981047  0.73769030 0.46070267
#> Mon     0.042733425 1.0436596 0.028942815  1.47647783 0.13981566
#> Tue     0.057910712 1.0596204 0.028772745  2.01269332 0.04414690
#> Wed    -0.010008025 0.9900419 0.029171937 -0.34307029 0.73154558
#> Thu    -0.016790296 0.9833499 0.029455877 -0.57001513 0.56866744
#> Fri     0.027247952 1.0276226 0.029173235  0.93400517 0.35030123
#> Sat     0.001855841 1.0018576 0.028900116  0.06421568 0.94879849

# works with "broom" style tidiers:
# data frame of estimate, std. error, p-value for each model term
# similar to "summary", but in a dataframe
tidy(model1)
#> # A tibble: 8 × 5
#>   term   estimate std.error statistic p.value
#>   <chr>     <dbl>     <dbl>     <dbl>   <dbl>
#> 1 o3mean -0.00288   0.00113   -2.55    0.0107
#> 2 tmpd    0.00146   0.00198    0.738   0.461 
#> 3 Mon     0.0427    0.0289     1.48    0.140 
#> 4 Tue     0.0579    0.0288     2.01    0.0441
#> 5 Wed    -0.0100    0.0292    -0.343   0.732 
#> 6 Thu    -0.0168    0.0295    -0.570   0.569 
#> 7 Fri     0.0272    0.0292     0.934   0.350 
#> 8 Sat     0.00186   0.0289     0.0642  0.949 
# exponentiate the coefficient estimates
tidy(model1, exponentiate = TRUE)
#> # A tibble: 8 × 5
#>   term   estimate std.error statistic p.value
#>   <chr>     <dbl>     <dbl>     <dbl>   <dbl>
#> 1 o3mean -0.00288   0.00113   -2.55    0.0107
#> 2 tmpd    0.00146   0.00198    0.738   0.461 
#> 3 Mon     0.0427    0.0289     1.48    0.140 
#> 4 Tue     0.0579    0.0288     2.01    0.0441
#> 5 Wed    -0.0100    0.0292    -0.343   0.732 
#> 6 Thu    -0.0168    0.0295    -0.570   0.569 
#> 7 Fri     0.0272    0.0292     0.934   0.350 
#> 8 Sat     0.00186   0.0289     0.0642  0.949 
# include confidence intervals in output
tidy(model1, conf.int = TRUE)
#> # A tibble: 8 × 5
#>   term   estimate std.error statistic p.value
#>   <chr>     <dbl>     <dbl>     <dbl>   <dbl>
#> 1 o3mean -0.00288   0.00113   -2.55    0.0107
#> 2 tmpd    0.00146   0.00198    0.738   0.461 
#> 3 Mon     0.0427    0.0289     1.48    0.140 
#> 4 Tue     0.0579    0.0288     2.01    0.0441
#> 5 Wed    -0.0100    0.0292    -0.343   0.732 
#> 6 Thu    -0.0168    0.0295    -0.570   0.569 
#> 7 Fri     0.0272    0.0292     0.934   0.350 
#> 8 Sat     0.00186   0.0289     0.0642  0.949 
# change confidence interval amount
tidy(model1, conf.int = TRUE)
#> # A tibble: 8 × 5
#>   term   estimate std.error statistic p.value
#>   <chr>     <dbl>     <dbl>     <dbl>   <dbl>
#> 1 o3mean -0.00288   0.00113   -2.55    0.0107
#> 2 tmpd    0.00146   0.00198    0.738   0.461 
#> 3 Mon     0.0427    0.0289     1.48    0.140 
#> 4 Tue     0.0579    0.0288     2.01    0.0441
#> 5 Wed    -0.0100    0.0292    -0.343   0.732 
#> 6 Thu    -0.0168    0.0295    -0.570   0.569 
#> 7 Fri     0.0272    0.0292     0.934   0.350 
#> 8 Sat     0.00186   0.0289     0.0642  0.949 
```

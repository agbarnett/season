# Summary for a Monthglm

The default summary method for an object produced by
[`monthglm()`](monthglm.md).

## Usage

``` r
# S3 method for class 'monthglm'
summary(object, ...)
```

## Arguments

- object:

  a `monthglm` object produced by [`nscosinor()`](nscosinor.md).

- ...:

  further arguments passed to or from other methods.

## Value

a list with the following elements:

- n: sample size.

- month.ests: parameter estimates for the intercept and months.

- month.effect: scale of the monthly effects. `RR` for rate ratios, `OR`
  for odds ratios, or empty otherwise.

## Details

The estimates are the mean, 95\\ p-value (comparing each month to the
reference month). If Poisson regression was used then the estimates are
shown as rate ratios. If logistic regression was used then the estimates
are shown as odds ratios.

## See also

`monthglm`, `plot.monthglm`

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
mmodel <- monthglm(
  formula = cvd~1,
  data = CVD,
  family = poisson(),
  offsetpop = expression(pop/100000),
  offsetmonth = TRUE
  )
summary(mmodel)
#> Number of observations = 168 
#> Rate ratios
#>  
#>                mean     lower     upper     zvalue        pvalue
#> monthsFeb 0.9001334 0.8835557 0.9170223 -11.093389  1.350710e-28
#> monthsMar 0.8248895 0.8097153 0.8403480 -20.321628  8.278563e-92
#> monthsApr 0.7861180 0.7713300 0.8011895 -24.836563 3.612571e-136
#> monthsMay 0.7431550 0.7290823 0.7574993 -30.432988 2.011735e-203
#> monthsJun 0.7169580 0.7031100 0.7310788 -33.437125 3.960379e-245
#> monthsJul 0.7001582 0.6866705 0.7139109 -35.915811 1.730663e-282
#> monthsAug 0.7037277 0.6901913 0.7175297 -35.456352 2.315335e-275
#> monthsSep 0.7033356 0.6896741 0.7172678 -35.164379 7.008762e-271
#> monthsOct 0.7365838 0.7226003 0.7508379 -31.263630 1.457403e-214
#> monthsNov 0.7894712 0.7746378 0.8045886 -24.426747 8.891612e-132
#> monthsDec 0.9286091 0.9120533 0.9454655  -8.069682  7.048164e-16
```

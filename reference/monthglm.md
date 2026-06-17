# Fit a GLM with Month

Fit a generalized linear model with a categorical variable of month.

## Usage

``` r
monthglm(
  formula,
  data,
  family = stats::gaussian(),
  refmonth = 1,
  monthvar = "month",
  offsetmonth = FALSE,
  offsetpop = NULL
)
```

## Arguments

- formula:

  regression model formula, e.g., `y~x1+x2`, (do not add month to the
  regression equation, it will be added automatically).

- data:

  a data frame. Must contain the column "months" as integer, and year as
  a 4 digit number.

- family:

  a description of the error distribution and link function to be used
  in the model
  (default=[`gaussian()`](https://rdrr.io/r/stats/family.html)). (See
  [`family()`](https://rdrr.io/r/stats/family.html) for details of
  family functions.).

- refmonth:

  reference month, must be between 1 and 12 (default=1 for January).

- monthvar:

  name of the month variable which is either an integer (1 to 12) or a
  character or factor (`Jan' to `Dec' or `January' to `December')
  (default='month').

- offsetmonth:

  include an offset to account for the uneven number of days in the
  month (TRUE/FALSE). Should be used for monthly counts (with
  `family=poisson()`).

- offsetpop:

  include an offset for the population (optional), this should be a
  variable in the data frame. Do not log-transform the offset as the
  log-transform is applied by the function. This should be an
  expression, as given in the example below.

## Value

a list with the following elements:

- call: the original call to the monthglm function.

- fit: GLM model.

- fitted: fitted values.

- residuals: residuals.

- out: details on the monthly estimates.

## Details

Month is fitted as a categorical variable as part of a generalized
linear model. Other independent variables can be added to the right-hand
side of `formula`.

This model is useful for examining non-sinusoidal seasonal patterns. For
sinusoidal seasonal patterns see [`cosinor()`](cosinor.md).

The data frame should contain the integer months and the year as a 4
digit number. These are used to calculate the number of days in each
month accounting for leap years.

## References

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## See also

`summary.monthglm`, `plot.monthglm`

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r

model <- monthglm(
  formula = cvd~1,
  data = CVD,
  family = poisson(),
  offsetpop = expression(pop/100000),
  offsetmonth = TRUE
  )
summary(model)
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

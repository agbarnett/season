# Print and summary methods for a Cosinor

Print and summary methods for a `Cosinor` object produced by
[`cosinor()`](cosinor.md).
[`summary()`](https://rdrr.io/r/base/summary.html) summarises the
sinusoidal seasonal pattern and tests whether there is a statistically
significant seasonal or circadian pattern (assuming a smooth sinusoidal
pattern). The amplitude describes the average height of the sinusoid,
and the phase describes the location of the peak. The scale of the
amplitude depends on the link function: for logistic regression the
amplitude is given on a probability scale; for Poisson regression the
amplitude is given on an absolute scale.
[`print()`](https://rdrr.io/r/base/print.html) uses the `glm` method for
[`print()`](https://rdrr.io/r/base/print.html) on the underlying model.

## Usage

``` r
# S3 method for class 'Cosinor'
summary(object, digits = 2, ...)

# S3 method for class 'Cosinor'
print(x, ...)

# S3 method for class 'summary.Cosinor'
print(x, ...)
```

## Arguments

- object:

  a `Cosinor` object produced by [`cosinor()`](cosinor.md).

- digits:

  minimal number of significant digits, see
  [`print.default()`](https://rdrr.io/r/base/print.default.html).

- ...:

  further arguments passed to or from other methods.

- x:

  a `Cosinor` or `summary.Cosinor` object.

## Value

`summary.Cosinor()` returns a list with the following named elements:

- n: sample size.

- amp: estimated amplitude.

- amp.scale: the scale of the estimated amplitude (empty for standard
  regression; "probability scale" for logistic regression; "absolute
  scale" for Poisson regression).

- phase: estimated peak phase on a time scale.

- lphase: estimated low phase on a time scale (half a year after/before
  `phase`).

- significant: statistically significant sinusoid (TRUE/FALSE).

- alpha: statistical significance level.

- digits: minimal number of significant digits.

- text: add explanatory text to the returned phase value (TRUE) or
  return a number (FALSE).

- type: type of data (yearly/monthly/weekly/hourly).

- ctable: table of regression coefficients.

`print.Cosinor()` and `print.summary.Cosinor()` are called for their
side effect of printing to the console and invisibly return `x`.

summary of output from [`cosinor()`](cosinor.md).

## Methods (by generic)

- `print(summary.Cosinor)`: Print a `summary.Cosinor` object: amplitude,
  phase, statistical significance, and the regression coefficient table.

## Functions

- `print(Cosinor)`: Print basic results from [`cosinor()`](cosinor.md)
  using the `glm` print method.

## See also

[`cosinor()`](cosinor.md) [`plot.Cosinor()`](plot.Cosinor.md)
[`invyrfraction()`](invyrfraction.md)
[`glm()`](https://rdrr.io/r/stats/glm.html)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
## cardiovascular disease data (offset based on number of days in...
## ...the month scaled to an average month length)
res <- cosinor(
  cvd ~ 1,
  date = 'month',
  data = CVD,
  type = 'monthly',
  family = poisson(),
  offsetmonth = TRUE
  )
res
#> 
#> Call:  stats::glm(formula = form, family = family, data = data, offset = offset)
#> 
#> Coefficients:
#> (Intercept)         cosw         sinw  
#>     7.21933      0.15552      0.02237  
#> 
#> Degrees of Freedom: 167 Total (i.e. Null);  165 Residual
#> Null Deviance:       4330 
#> Residual Deviance: 1496  AIC: 3023
summary(res)
#> Cosinor test:
#> Number of observations = 168 
#> Amplitude = 232.34 (absolute scale) 
#> Phase: Month = 1.3 
#> Low point: Month = 7.3 
#> Significant seasonality based on adjusted significance level of 0.025  =  TRUE 
#> 
#> Regression coefficients:
#>               Estimate  Std..Error     z.value     Pr...z..
#> (Intercept) 7.21933179 0.002093436 3448.557005 0.000000e+00
#> cosw        0.15552367 0.002955997   52.612939 0.000000e+00
#> sinw        0.02237303 0.002949022    7.586594 3.284251e-14
# }
# \donttest{
## cardiovascular disease data (offset based on number of days in...
## ...the month scaled to an average month length)
res <- cosinor(
  cvd ~ 1,
  date = 'month',
  data = CVD,
  type = 'monthly',
  family = poisson(),
  offsetmonth = TRUE
  )
res
#> 
#> Call:  stats::glm(formula = form, family = family, data = data, offset = offset)
#> 
#> Coefficients:
#> (Intercept)         cosw         sinw  
#>     7.21933      0.15552      0.02237  
#> 
#> Degrees of Freedom: 167 Total (i.e. Null);  165 Residual
#> Null Deviance:       4330 
#> Residual Deviance: 1496  AIC: 3023
summary(res)
#> Cosinor test:
#> Number of observations = 168 
#> Amplitude = 232.34 (absolute scale) 
#> Phase: Month = 1.3 
#> Low point: Month = 7.3 
#> Significant seasonality based on adjusted significance level of 0.025  =  TRUE 
#> 
#> Regression coefficients:
#>               Estimate  Std..Error     z.value     Pr...z..
#> (Intercept) 7.21933179 0.002093436 3448.557005 0.000000e+00
#> cosw        0.15552367 0.002955997   52.612939 0.000000e+00
#> sinw        0.02237303 0.002949022    7.586594 3.284251e-14
# }
## hourly indoor temperature data
res <- cosinor(
  bedroom ~ 1,
  date = 'datetime',
  type = 'hourly',
  data = indoor
)
summary(res)
#> Cosinor test:
#> Number of observations = 2021 
#> Amplitude = 3.19  
#> Phase: Hour = 7.7 
#> Low point: Hour = 19.7 
#> Significant circadian pattern based on adjusted significance level of 0.025  =  TRUE 
#> 
#> Regression coefficients:
#>              Estimate Std..Error   t.value      Pr...t..
#> (Intercept) 19.880382 0.07194127 276.34183  0.000000e+00
#> cosw        -1.345546 0.10179658 -13.21799  2.574413e-38
#> sinw         2.887552 0.10168383  28.39736 1.586551e-149
# to get the p-values for the sine and cosine estimates
summary(res$glm)
#> 
#> Call:
#> stats::glm(formula = form, family = family, data = data, offset = offset)
#> 
#> Coefficients:
#>             Estimate Std. Error t value Pr(>|t|)    
#> (Intercept) 19.88038    0.07194  276.34   <2e-16 ***
#> cosw        -1.34555    0.10180  -13.22   <2e-16 ***
#> sinw         2.88755    0.10168   28.40   <2e-16 ***
#> ---
#> Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#> 
#> (Dispersion parameter for gaussian family taken to be 10.45967)
#> 
#>     Null deviance: 31358  on 2020  degrees of freedom
#> Residual deviance: 21108  on 2018  degrees of freedom
#> AIC: 10485
#> 
#> Number of Fisher Scoring iterations: 2
#> 
```

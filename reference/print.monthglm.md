# Prints basic results from [`monthglm()`](monthglm.md)

Prints basic results from [`monthglm()`](monthglm.md)

## Usage

``` r
# S3 method for class 'monthglm'
print(x, ...)
```

## Arguments

- x:

  Object of class `monthglm`

- ...:

  further arguments passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html), or from
  other methods.

## Value

basic summary using the `glm` method for
[`print()`](https://rdrr.io/r/base/print.html)..

## Examples

``` r
# \donttest{
mmodel <- monthglm(
  formula = cvd~1,
  data = CVD,
  family = poisson(),
  offsetpop = expression(pop/100000),
  offsetmonth = TRUE
  )
mmodel
#> 
#> Call:  stats::glm(formula = form, family = family, data = data, offset = model_offset)
#> 
#> Coefficients:
#> (Intercept)    monthsFeb    monthsMar    monthsApr    monthsMay    monthsJun  
#>     5.99789     -0.10521     -0.19251     -0.24065     -0.29685     -0.33274  
#>   monthsJul    monthsAug    monthsSep    monthsOct    monthsNov    monthsDec  
#>    -0.35645     -0.35136     -0.35192     -0.30573     -0.23639     -0.07407  
#> 
#> Degrees of Freedom: 167 Total (i.e. Null);  156 Residual
#> Null Deviance:       4330 
#> Residual Deviance: 1066  AIC: 2611
# }
```

# Construct a single row summary "glance" of a model, fit, or other object

Construct a single row summary "glance" of a model, fit, or other object

## Usage

``` r
# S3 method for class 'casecross'
glance(x, ...)
```

## Arguments

- x:

  model or other R object to convert to single-row data frame.

- ...:

  other arguments passed to methods.

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
# one-line summary for each model
glance(model1)
#> # A tibble: 1 × 18
#>       n nevent statistic.log p.value.log statistic.sc p.value.sc statistic.wald
#>   <int>  <dbl>         <dbl>       <dbl>        <dbl>      <dbl>          <dbl>
#> 1  8815    365          20.4     0.00901         20.4    0.00888           20.4
#> # ℹ 11 more variables: p.value.wald <dbl>, statistic.robust <dbl>,
#> #   p.value.robust <dbl>, r.squared <dbl>, r.squared.max <dbl>,
#> #   concordance <dbl>, std.error.concordance <dbl>, logLik <dbl>, AIC <dbl>,
#> #   BIC <dbl>, nobs <dbl>
```

# Summary of the Results of a Case-crossover Model

The default summary method for an object produced by
[`casecross()`](casecross.md). Shows the number of control days, the
average number of control days per case days, and the parameter
estimates.

## Usage

``` r
# S3 method for class 'casecross'
summary(object, ...)
```

## Arguments

- object:

  a [`casecross()`](casecross.md) object produced by
  [`casecross()`](casecross.md).

- ...:

  further arguments passed to or from other methods.

## Value

The number of control days, the average number of control days per case
days, and the parameter estimates.

## See also

[`casecross()`](casecross.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# cardiovascular disease data
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
# match on day of the week
model2 <- casecross(cvd ~ o3mean + tmpd, matchdow = TRUE, data = CVDdaily)
summary(model2)
#> Time-stratified case-crossover with a stratum length of 28 days
#> Matched on day of the week
#> Total number of cases 17502 
#> Number of case days with available control days 364 
#> Average number of control days per case day 3 
#> 
#> Parameter Estimates:
#>                 coef exp(coef)    se(coef)          z    Pr(>|z|)
#> o3mean -0.0030752572 0.9969295 0.001188540 -2.5874238 0.009669658
#> tmpd   -0.0004095116 0.9995906 0.002131744 -0.1921017 0.847662557
# match on temperature to within a degree
model3 <- casecross(
  cvd ~ o3mean + Mon + Tue + Wed + Thu + Fri + Sat,
  data = CVDdaily,
  matchconf = 'tmpd',
  confrange = 1
)
summary(model3)
#> Time-stratified case-crossover with a stratum length of 28 days
#> Matched on tmpd plus/minus 1 
#> Total number of cases 15180 
#> Number of case days with available control days 318 
#> Average number of control days per case day 4.9 
#> 
#> Parameter Estimates:
#>                coef exp(coef)   se(coef)          z     Pr(>|z|)
#> o3mean -0.003238583 0.9967667 0.00131839 -2.4564691 1.403099e-02
#> Mon     0.182058170 1.1996840 0.03577818  5.0885255 3.608582e-07
#> Tue     0.144181049 1.1550932 0.03563272  4.0463108 5.203115e-05
#> Wed     0.099443480 1.1045560 0.03554924  2.7973451 5.152447e-03
#> Thu     0.088518237 1.0925542 0.03459482  2.5587140 1.050601e-02
#> Fri     0.108107305 1.1141673 0.03437323  3.1451022 1.660288e-03
#> Sat     0.023660066 1.0239422 0.03525152  0.6711786 5.021068e-01
# }
```

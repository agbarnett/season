# Case–crossover Analysis to Control for Seasonality

Fits a time-stratified case–crossover to regularly spaced time series
data. The function is not suitable for irregularly spaced individual
data. The function only uses a time-stratified design, and other designs
such as the symmetric bi-directional design, are not available.

## Usage

``` r
casecross(
  formula,
  data,
  exclusion = 2,
  stratalength = 28,
  matchdow = FALSE,
  usefinalwindow = TRUE,
  matchconf = NULL,
  confrange = 0,
  stratamonth = FALSE,
  date_col = "date"
)
```

## Arguments

- formula:

  formula. The dependent variable should be an integer count (e.g.,
  daily number of deaths).

- data:

  data set as a data frame.

- exclusion:

  exclusion period (in days) around cases, set to 2 (default). Must be
  greater than or equal to zero and smaller than `stratalength`.

- stratalength:

  length of stratum in days, set to 28 (default).

- matchdow:

  match case and control days using day of the week
  (TRUE/default=FALSE). This matching is in addition to the strata
  matching.

- usefinalwindow:

  use the last stratum in the time series, which is likely to contain
  less days than all the other strata (TRUE/default=FALSE).

- matchconf:

  match case and control days using an important confounder (optional;
  must be in quotes). `matchconf` is the variable to match on. This
  matching is in addition to the strata matching. Default is NULL - no
  confounder is used.

- confrange:

  range of the confounder within which case and control days will be
  treated as a match (optional). Range = `matchconf` (on case day)
  \\+/-\\ `confrange`.

- stratamonth:

  use strata based on months, default=FALSE. Instead of a fixed strata
  size when using `stratalength`.

- date_col:

  Character. column name for date variable. Default is "date".

## Value

a list with the following elements:

- call: the original call to the casecross function.

- cox_model: conditional logistic regression model of class `coxph`.

- n_cases: total number of cases.

- n_case_days: number of case days with at least one control day.

- n_control_days: average number of control days per case day.

## Details

The case–crossover method compares "case" days when events occurred
(e.g., deaths) with control days to look for differences in exposure
that might explain differences in the number of cases. Control days are
selected to be nearby to case days, which means that only recent changes
in the independent variable(s) are compared. By only comparing recent
values, any long-term or seasonal variation in the dependent and
independent variable(s) can be eliminated. This elimination depends on
the definition of nearby and on the seasonal and long-term patterns in
the independent variable(s).

Control and case days are only compared if they are in the same stratum.
The stratum is controlled by `stratalength`, the default value is 28
days, so that cases and controls are compared in four week sections.
Smaller stratum lengths provide a closer control for season, but reduce
the available number of controls. Control days that are close to the
case day may have similar levels of the independent variable(s). To
reduce this correlation it is possible to place an `exclusion` around
the cases. The default is 2, which means that the smallest gap between a
case and control will be 3 days.

To remove any confounding by day of the week it is possible to
additionally match by day of the week (`matchdow`), although this
usually reduces the number of available controls. This matching is in
addition to the strata matching.

It is possible to additionally match case and control days by an
important confounder (`matchconf`) in order to remove its effect.
Control days are matched to case days if they are: i) in the same
strata, ii) have the same day of the week if `matchdow=TRUE`, iii) have
a value of `matchconf` that is within plus/minus `confrange` of the
value of `matchconf` on the case day.

If the range is set too narrow then the number of available controls
will become too small, which in turn means the number of case days with
at least one control day is compromised.

The method uses conditional logistic regression (see
[`survival::coxph()`](https://rdrr.io/pkg/survival/man/coxph.html)), so
the parameter estimates are odds ratios.

The code assumes that the data frame contains a date variable (in
[`Date()`](https://rdrr.io/r/base/Dates.html) format) called "date".

## References

Janes, H., Sheppard, L., Lumley, T. (2005) Case-crossover analyses of
air pollution exposure data: Referent selection strategies and their
implications for bias. *Epidemiology* 16(6), 717–726.
[doi:10.1097/01.ede.0000181315.18836.9d.](https://doi.org/10.1097/01.ede.0000181315.18836.9d.)

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## See also

`summary.casecross`, `coxph`

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
  matchconf = "tmpd",
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

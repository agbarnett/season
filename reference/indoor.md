# Indoor Temperature Data

The data are indoor temperatures (in degrees C) for a bedroom and living
room in a house in Brisbane, Australia for the dates 10 July 2013 to 3
October 2013. Temperatures were recorded using data loggers which
recorded every hour to the nearest 0.5 degrees.

## Format

A `data.frame` with the following 3 variables:

- datetime: date and time in `POSIXlt` format

- living: the living room temperature

- bedroom: the bedroom temperature

## Source

Adrian G Barnett.

## Examples

``` r

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
```

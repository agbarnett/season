# Stillbirths in Queensland, 1998–2000

Monthly number of stillbirths in Australia from 1998 to 2000. It is a
rare event; there are 352 stillbirths out of 60,110 births. To preserve
confidentiality the day of birth has been randomly re-ordered.

## Usage

``` r
stillbirth
```

## Format

A data frame with 60,110 observations on the following 7 variables:

- dob: date of birth (year-month-day)

- year: year of birth

- month: month of birth

- yrmon: a combination of year and month: \\year+(month-1)/12\\

- seifa: SEIFA score, an area level measure of socioeconomic status in
  quintiles

- gestation: gestation in weeks

- stillborn: stillborn (yes/no); 1=Yes, 0=No

## Source

From Queensland Health.

## Examples

``` r

table(stillbirth$month, stillbirth$stillborn)
#>     
#>         0    1
#>   1  4883   37
#>   2  4603   30
#>   3  5409   36
#>   4  4926   27
#>   5  5096   33
#>   6  5013   23
#>   7  5214   26
#>   8  5075   25
#>   9  5154   26
#>   10 5050   25
#>   11 4650   32
#>   12 4685   32
```

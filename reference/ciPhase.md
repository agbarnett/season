# Mean and Confidence Interval for Circular Phase

Calculates the mean and confidence interval for the phase based on a
chain of MCMC samples.

## Usage

``` r
ciPhase(theta, alpha = 0.05)
```

## Arguments

- theta:

  chain of Markov chain Monte Carlo (MCMC) samples of the phase.

- alpha:

  the confidence level (default = 0.05 for a 95\\ interval).

## Value

a tibble with the following columns:

- mean: the estimated mean phase.

- lower: the estimated lower limit of the confidence interval.

- upper: the estimated upper limit of the confidence interval.

## Details

The estimates of the phase are rotated to have a centre of \\\pi\\, the
point on the circumference of a unit radius circle that is furthest from
zero. The mean and confidence interval are calculated on the rotated
values, then the estimates are rotated back.

## References

Fisher, N. (1993) *Statistical Analysis of Circular Data*. Cambridge
University Press. Page 36.

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
# 2000 normal samples, centred on zero
theta <- rnorm(n = 2000, mean = 0, sd = pi / 50)
hist(theta, breaks = seq(-pi / 8, pi / 8, pi / 30))

ciPhase(theta)
#> # A tibble: 1 × 3
#>       mean  lower upper
#>      <dbl>  <dbl> <dbl>
#> 1 -0.00146 -0.121 0.114
# }
```

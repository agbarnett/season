# Phase from Cosinor Estimates

Calculate the phase given the estimated sine and cosine values from a
cosinor model. Returns the phase in radians, in the range \\\[0,2\pi)\\.
The phase is the peak in the sinusoid. Applies
[`atan2()`](https://rdrr.io/r/base/Trig.html) over a branching workflow
for each coordinate. See <https://en.wikipedia.org/wiki/Atan2> for more
information.

## Usage

``` r
phasecalc(cosine, sine)
```

## Arguments

- cosine:

  estimated cosine value from a cosinor model.

- sine:

  estimated sine value from a cosinor model.

## Value

the estimated phase in radians.

## References

Fisher, N.I. (1993) *Statistical Analysis of Circular Data*. Cambridge
University Press, Cambridge. Page 31.

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# pi/2
phasecalc(cosine=0, sine=1)
#> [1] 1.570796
```

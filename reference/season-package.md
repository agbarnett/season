# season: Tools for Uncovering and Estimating Seasonal Patterns.

The package contains graphical methods for displaying seasonal data and
regression models for detecting and estimating seasonal patterns.

## Details

The regression models can be applied to normal, Poisson or binomial
dependent data distributions. Tools are available for both time series
data (equally spaced in time) and survey data (unequally spaced in
time).

Sinusoidal (parametric) seasonal patterns are available
([`cosinor()`](cosinor.md), [`nscosinor()`](nscosinor.md)), as well as
models for monthly data ([`monthglm()`](monthglm.md)), and the
case-crossover method to control for seasonality
([`casecross()`](casecross.md)).

`season` aims to fill an important gap in the software by providing a
range of tools for analysing seasonal data. The examples are based on
health data, but the functions are equally applicable to any data with a
seasonal pattern.

## References

Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
Springer.
[doi:10.1007/978-3-642-10748-1](https://doi.org/10.1007/978-3-642-10748-1)

## See also

Useful links:

- <https://github.com/agbarnett/season>

- Report bugs at <https://github.com/agbarnett/season/issues>

## Author

Adrian Barnett <a.barnett@qut.edu.au>  
Peter Baker  
Oliver Hughes

Maintainer: Adrian Barnett <a.barnett@qut.edu.au>

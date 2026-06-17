# Periodogram

Estimated periodogram using the fast Fourier transform (`fft`).

## Usage

``` r
peri(data, adjmean = TRUE, plot = lifecycle::deprecated())
```

## Arguments

- data:

  a data frame.

- adjmean:

  subtract the mean from the series before calculating the periodogram
  (default=TRUE).

- plot:

  **\[deprecated\]** Use [`autoplot.peri()`](autoplot.peri.md) on the
  returned object instead.

## Value

an object of class `"peri"` (a tibble) with the columns:

- peri: periodogram, I(\\\omega\\).

- freq_radians: frequencies in radians, \\\omega\\.

- freq_cycles: frequencies in cycles of time, \\2\pi/\omega\\.

- amp: amplitude periodogram.

- phase: phase periodogram.

Pass the result to [autoplot()](autoplot.peri.md) to draw the plot.

## See also

[`autoplot.peri()`](autoplot.peri.md)

## Author

Adrian Barnett <a.barnett@qut.edu.au>

## Examples

``` r
# \donttest{
p <- peri(CVD$cvd)
autoplot(p)

# }
```

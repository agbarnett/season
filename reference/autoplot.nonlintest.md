# Plot the region of the third-order moment outside the test limits

Returns a ggplot contour plot of the third-order moment region that
exceeds the bootstrap test limits computed by
[`nonlintest()`](nonlintest.md). Returns `NULL` invisibly with an
informational message if no points exceed the limits.

## Usage

``` r
# S3 method for class 'nonlintest'
autoplot(object, ...)
```

## Arguments

- object:

  a `nonlintest` object produced by [`nonlintest()`](nonlintest.md).

- ...:

  unused, for S3 generic compatibility.

## Value

a ggplot contour plot, or `NULL` invisibly when no points exceed the
test limits.

## See also

[`nonlintest()`](nonlintest.md)

## Author

Nicholas Tierney

## Examples

``` r
# \donttest{
if (FALSE) { # \dontrun{
test_res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 1000)
autoplot(test_res)
} # }
# }
```

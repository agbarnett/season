# season 0.3.16.9000

* Added a `NEWS.md` file to track changes to the package.

## New features

* New vignette, "Modelling monthly data", which demonstrates how to use `createAdj()` with the `{nimble}` R package.
* `autoplot()` (the ggplot version of base R's `plot` method) methods added for `peri`, `third`, `Cosinor`, `monthglm`, `Monthmean`, `nsCosinor`, and `nonlintest` classes. Each returns a ggplot object that can be extended with `+ theme_bw()`, `+ labs()`, etc. (#42, #33). 
* New `plot_circle()` and `plot_month()` functions return ggplot objects (#42).

## Deprecations

* The `plot` argument of `peri()` and `third()` is soft-deprecated. These functions now always return a classed object (`"peri"`, `"third"`); use `autoplot()` to draw the plot. Passing `plot = FALSE` is also deprecated — just drop the argument (#33).
* `plot.Cosinor()`, `plot.monthglm()`, `plot.Monthmean()`, `plot.nsCosinor()`, and `plot.nonlintest()` are soft-deprecated in favour of `autoplot()` methods. The base R / ggplot output of the deprecated `plot()` methods is unchanged — only the recommended path has moved.
* The `plot` argument of `plot.nonlintest()` is soft-deprecated.
* `plotCircle()` and `plotMonth()` are soft-deprecated in favour of new ggplot-returning `plot_circle()` and `plot_month()`. The deprecated functions continue to produce their existing output until removal.

All deprecated paths emit a one-time warning per session pointing at the replacement.

## Breaking change

* `monthmean()` argument, `adjmonth` must be one of "none" (default), "thirty", or "average", rather than: FALSE, "thirty", or "average".
* `createAdj()` argument, `filepath` has been removed, as it is no longer required.
* `casecross()` argument, `usefinalwindow` now defaults to TRUE, not FALSE.
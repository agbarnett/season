# Changelog

## season 0.3.16.9000

- Added a `NEWS.md` file to track changes to the package.

### New features

- New vignette, “Modelling monthly data”, which demonstrates how to use
  [`createAdj()`](../reference/createAdj.md) with the
  [nimble](https://r-nimble.org) R package.
- [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
  (the ggplot version of base R’s `plot` method) methods added for
  `peri`, `third`, `Cosinor`, `monthglm`, `Monthmean`, `nsCosinor`, and
  `nonlintest` classes. Each returns a ggplot object that can be
  extended with `+ theme_bw()`, `+ labs()`, etc.
  ([\#42](https://github.com/agbarnett/season/issues/42),
  [\#33](https://github.com/agbarnett/season/issues/33)).
- New [`plot_circle()`](../reference/plot_circle.md) and
  [`plot_month()`](../reference/plot_month.md) functions return ggplot
  objects ([\#42](https://github.com/agbarnett/season/issues/42)).
- added broom tidiers:
  [`tidy()`](https://generics.r-lib.org/reference/tidy.html),
  [`augment()`](https://generics.r-lib.org/reference/augment.html), and
  [`glance()`](https://generics.r-lib.org/reference/glance.html)
  ([\#39](https://github.com/agbarnett/season/issues/39))
- Made [`ciPhase()`](../reference/ciPhase.md) return data.frame rather
  than list() ([\#43](https://github.com/agbarnett/season/issues/43))
- Made [`invyrfraction_chr()`](../reference/invyrfraction.md) and
  [`invyrfraction_num()`](../reference/invyrfraction.md) to avoid
  specifying `text = TRUE/FALSE`, and make function use more explicit,
  ([\#43](https://github.com/agbarnett/season/issues/43))
- Made [`peri()`](../reference/peri.md) return a list with columns peri,
  freq_radians (formerly `f`) and freq_cycles
- made [`sinusoid()`](../reference/sinusoid.md) return a tibble(), and
  made an autoplot method
- removed cat() print in [`wtest()`](../reference/wtest.md) and return a
  `tibble` not a [`list()`](https://rdrr.io/r/base/list.html)
- For `nscosinor`, now optionally specify year and month column name, so
  you don’t need to have columns specifically named “year” or “month” -
  they could be “yr”, or “mn” even.
  [\#44](https://github.com/agbarnett/season/issues/44)
- For `casecross`, now optionally specify date column name, so you don’t
  need to have columns specifically named “date”.
  [\#44](https://github.com/agbarnett/season/issues/44)

### Deprecations

- The `plot` argument of [`peri()`](../reference/peri.md) and
  [`third()`](../reference/third.md) is soft-deprecated. These functions
  now always return a classed object (`"peri"`, `"third"`); use
  [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
  to draw the plot. Passing `plot = FALSE` is also deprecated — just
  drop the argument
  ([\#33](https://github.com/agbarnett/season/issues/33)).
- [`plot.Cosinor()`](../reference/plot.Cosinor.md),
  [`plot.monthglm()`](../reference/plot.monthglm.md),
  [`plot.Monthmean()`](../reference/plot.Monthmean.md),
  [`plot.nsCosinor()`](../reference/plot.nsCosinor.md), and
  [`plot.nonlintest()`](../reference/plot.nonlintest.md) are
  soft-deprecated in favour of
  [`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
  methods. The base R / ggplot output of the deprecated
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) methods is
  unchanged — only the recommended path has moved.
- The `plot` argument of
  [`plot.nonlintest()`](../reference/plot.nonlintest.md) is
  soft-deprecated.
- [`plotCircle()`](../reference/plotCircle.md) and
  [`plotMonth()`](../reference/plotMonth.md) are soft-deprecated in
  favour of new ggplot-returning
  [`plot_circle()`](../reference/plot_circle.md) and
  [`plot_month()`](../reference/plot_month.md). The deprecated functions
  continue to produce their existing output until removal.

All deprecated paths emit a one-time warning per session pointing at the
replacement.

### Breaking change

- [`monthmean()`](../reference/monthmean.md) argument, `adjmonth` must
  be one of “none” (default), “thirty”, or “average”, rather than:
  FALSE, “thirty”, or “average”.
- [`createAdj()`](../reference/createAdj.md) argument, `filepath` has
  been removed, as it is no longer required.
- [`casecross()`](../reference/casecross.md) argument, `usefinalwindow`
  now defaults to TRUE, not FALSE.

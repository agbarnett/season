# plot.nonlintest errors on non-nonlintest input

    Code
      plot.nonlintest(list(a = 1))
    Condition
      Warning:
      `plot.nonlintest()` was deprecated in season 0.3.17.
      Use `autoplot()` for a ggplot object you can extend:
      i  autoplot(x) + ggplot2::theme_bw()
      Error in `plot.nonlintest()`:
      ! `x` must be of class <nonlintest>.
      i We see class <list>.

# plotMonth errors when panels is not 1 or 12

    Code
      plotMonth(data = CVD, resp = "cvd", panels = 4)
    Condition
      Warning:
      `plotMonth()` was deprecated in season 0.3.17.
      i Please use `plot_month()` instead.
      Error in `plotMonth()`:
      ! `panels` must be "1" or "12", not 4.


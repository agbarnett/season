# plot.nonlintest errors on non-nonlintest input

    Code
      plot.nonlintest(list(a = 1))
    Condition
      Error in `plot.nonlintest()`:
      ! `x` must be of class <nonlintest>.
      i We see class <list>.

# plotMonth errors when panels is not 1 or 12

    Code
      plotMonth(data = CVD, resp = "cvd", panels = 4)
    Condition
      Error in `plotMonth()`:
      ! `panels` must be "1" or "12", not 4.


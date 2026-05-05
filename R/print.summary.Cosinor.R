# October 2011
#' Printing a summary of a Cosinor
#' @param x a `summary.Cosinor` object produced by [summary.Cosinor()]
#' @param \dots optional arguments to [print()] or [plot()] methods.
#' @returns summary of Cosinor test
#' @returns
#' ## cardiovascular disease data (offset based on number of days in...
#' ## ...the month scaled to an average month length)
#' res <- cosinor(
#'   cvd ~ 1,
#'   date = 'month',
#'   data = CVD,
#'   type = 'monthly',
#'   family = poisson(),
#'   offsetmonth = TRUE
#'   )
#' summary(res)
#' @export
print.summary.Cosinor <- function(x, ...) {
  ## report results
  if (!inherits(x, "summary.Cosinor")) {
    stop("Object must be of class 'summary.Cosinor'")
  }
  # fix the digits, October 2011
  if (!x$text) {
    x$phase <- round(x$phase, x$digits)
    x$lphase <- round(x$lphase, x$digits)
  }

  cat('Cosinor test:\n')
  cat('Number of observations =', x$n, '\n')
  cat('Amplitude =', round(x$amp, x$digits), x$amp.scale, '\n')
  cat('Phase:', x$phase, '\n')
  cat('Low point:', x$lphase, '\n')
  if (x$type == 'hourly') {
    cat(
      'Significant circadian pattern based on adjusted significance level of',
      eval(x$alpha) / 2,
      ' = ',
      x$significant,
      '\n',
      ...
    )
  }
  if (x$type != 'hourly') {
    cat(
      'Significant seasonality based on adjusted significance level of',
      eval(x$alpha) / 2,
      ' = ',
      x$significant,
      '\n',
      ...
    )
  }

  # Added March 2020
  cat('\nRegression coefficients:\n')
  print(data.frame(x$ctable))
}

#' Plot of Monthly Mean Estimates
#'
#' `r lifecycle::badge("deprecated")` Soft-deprecated in favour of
#' [autoplot.Monthmean()], which returns a ggplot object you can extend
#' with `+`. The base R plot below still works.
#'
#' @param x a `Monthmean` object produced by [monthmean()].
#' @param \dots additional arguments passed to the plot.
#' @returns Connected dot plot of estimated monthly means.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [autoplot.Monthmean()], [monthmean()]
#' @export
#' @examples
#' \donttest{
#' mmean <- monthmean(
#'   data = CVD,
#'   resp = 'cvd',
#'   offsetpop = expression(pop / 100000),
#'   adjmonth = 'average'
#' )
#' mmean
#' # Recommended:
#' autoplot(mmean)
#' # Still works, but deprecated:
#' plot(mmean)
#' }
plot.Monthmean <- function(x, ...) {
  lifecycle::deprecate_warn(
    when = "0.3.17",
    what = "plot.Monthmean()",
    details = c(
      "Use `autoplot()` for a ggplot object you can extend:",
      i = "  autoplot(x) + ggplot2::theme_bw()"
    )
  )
  par(lwd = 2)
  plot(
    x$mean,
    type = 'o',
    bty = 'n',
    xaxt = 'n',
    xlab = 'Month',
    ylab = 'Mean',
    ...
  )
  box(lwd = 1)
  x.ticks <- seq(1, 12, 1)
  x.labels <- c('J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D')
  axis(side = 1, at = x.ticks, labels = x.labels)
}

#' Plot the monthly mean estimates from [monthmean()]
#'
#' Returns a ggplot of the per-month means computed by [monthmean()].
#'
#' @param object a `Monthmean` object produced by [monthmean()].
#' @param ... unused, for S3 generic compatibility.
#' @returns a ggplot object.
#' @author Nicholas Tierney
#' @seealso [monthmean()]
#' @examples
#' \donttest{
#' mmean <- monthmean(
#'   data = CVD,
#'   resp = "cvd",
#'   offsetpop = expression(pop / 100000),
#'   adjmonth = "average"
#' )
#' autoplot(mmean)
#' autoplot(mmean) + ggplot2::theme_minimal()
#' }
#' @export
autoplot.Monthmean <- function(object, ...) {
  check_if_monthmean(object)
  month <- mean <- NULL
  dat <- data.frame(
    month = seq_along(object$mean),
    mean = object$mean
  )
  ggplot2::ggplot(
    dat,
    ggplot2::aes(
      x = month,
      y = mean
    )
  ) +
    ggplot2::geom_line() +
    ggplot2::geom_point() +
    ggplot2::scale_x_continuous(
      breaks = 1:12,
      labels = substr(month.abb, 1, 1)
    ) +
    ggplot2::labs(
      x = "Month",
      y = "Mean"
    ) +
    ggplot2::theme_bw()
}

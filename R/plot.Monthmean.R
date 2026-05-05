#' Plot of Monthly Mean Estimates
#'
#' Plots estimated monthly means.
#'
#' @param x a `Monthmean` object produced by [monthmean()].
#' @param \dots additional arguments passed to the plot.
#' @returns Connected dot plot of estimated monthly means.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `monthmean`
#' @export
#' @examples
#' \donttest{
#' mmean <- monthmean(
#'   data=CVD,
#'   resp='cvd',
#'   offsetpop = expression(pop/100000),
#'   adjmonth = 'average'
#'   )
#'   mmean
#'   plot(mmean)
#' }
plot.Monthmean <- function(x, ...) {
  ## Check
  if (!inherits(x, "Monthmean")) {
    stop("Object must be of class 'Monthmean'")
  }
  ## Plot
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

#' Plot the Results of a Non-stationary Cosinor
#'
#' Plots the trend and season(s) from a `nsCosinor` object produced by
#' [nscosinor()].
#'
#' The code produces the season(s) and trend estimates.
#'
#' @param x a `nsCosinor` object produced by [nscosinor()].
#' @param \dots further arguments passed to or from other methods.
#' @return a plot of class `ggplot`.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [nscosinor()]
#' @export
#' @examples
#' \dontttest{
#' # model to fit an annual pattern to the monthly cardiovascular disease data
#' f <- 12
#' tau <- c(10,50)
#' \dontrun{
#'   res12 <- nscosinor(
#'     data = CVD,
#'     response = 'adj',
#'     cycles = f,
#'     niters = 200,
#'     burnin = 100,
#'     tau = tau
#'     )
#' plot(res12)
#' }
#' }
plot.nsCosinor <- function(x, ...) {
  ## basic variables
  cycles <- x$cycles
  k <- length(cycles)
  month <- (12 * (x$time - floor(x$time))) + 1

  # season
  smat <- as.matrix(x$season)
  # loop through seasons
  for (index in 1:k) {
    mean <- smat[, (index * 3) - 2]
    lower <- smat[, (index * 3) - 1]
    upper <- smat[, (index * 3)]
    type <- paste0("Season, cycle=", cycles[index])
    this.frame <- data.frame(
      time = x$time,
      mean = mean,
      lower = lower,
      upper = upper,
      type = type
    )
    if (index == 1) {
      season.frame <- this.frame
    } else {
      season.frame <- rbind(season.frame, this.frame)
    }
  }

  # trend
  trend.frame <- data.frame(
    time = x$time,
    mean = x$trend$mean,
    lower = x$trend$lower,
    upper = x$trend$upper,
    type = 'Trend'
  )
  plot.frame <- rbind(trend.frame, season.frame)

  # plot with ribbon
  gplot <- ggplot2::ggplot(
    plot.frame,
    ggplot2::aes(time, mean)
  ) +
    ggplot2::geom_ribbon(
      ggplot2::aes(
        ymin = lower,
        ymax = upper,
        alpha = 5
      ),
      show.legend = FALSE
    ) +
    ggplot2::geom_line() +
    ggplot2::theme_bw() +
    ggplot2::xlab('Time') +
    ggplot2::ylab(' ') +
    ggplot2::facet_grid(
      type ~ .,
      scales = 'free_y'
    )
  # print(gplot)

  # return
  return(gplot)
}

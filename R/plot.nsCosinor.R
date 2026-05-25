#' Plot the Results of a Non-stationary Cosinor
#'
#' `r lifecycle::badge("deprecated")` Soft-deprecated in favour of
#' [autoplot.nsCosinor()], which is the same ggplot — just nudges the
#' recommended idiom so users can `+ theme_bw()` etc.
#'
#' The code produces the season(s) and trend estimates.
#'
#' @param x a `nsCosinor` object produced by [nscosinor()].
#' @param \dots further arguments passed to or from other methods.
#' @returns a plot of class `ggplot`.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [autoplot.nsCosinor()], [nscosinor()]
#' @export
#' @examples
#' \donttest{
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
#' # Recommended:
#' autoplot(res12)
#' # Still works, but deprecated:
#' plot(res12)
#' }
#' }
plot.nsCosinor <- function(x, ...) {
  lifecycle::deprecate_warn(
    when = "0.3.17",
    what = "plot.nsCosinor()",
    details = c(
      "Use `autoplot()` for a ggplot object you can extend:",
      i = "  autoplot(x) + ggplot2::theme_minimal()"
    )
  )
  autoplot(x, ...)
}

#' Plot the trend and seasonal estimates from [nscosinor()]
#'
#' Returns a ggplot of the trend and seasonal components estimated by
#' [nscosinor()], faceted by component and with a ribbon for the
#' confidence interval.
#'
#' @param object an `nsCosinor` object produced by [nscosinor()].
#' @param ... unused, for S3 generic compatibility.
#' @returns a ggplot object faceted by trend / season(s).
#' @author Nicholas Tierney
#' @seealso [nscosinor()]
#' @examples
#' \donttest{
#' \dontrun{
#' res <- nscosinor(
#'   data = CVD, response = "adj", cycles = 12,
#'   niters = 200, burnin = 100, tau = c(10, 50)
#' )
#' autoplot(res)
#' autoplot(res) + ggplot2::theme_minimal()
#' }
#' }
#' @export
autoplot.nsCosinor <- function(object, ...) {
  check_if_nscosinor(object)
  mean <- lower <- upper <- type <- NULL
  cycles <- object$cycles
  k <- length(cycles)
  smat <- as.matrix(object$season)
  season_frames <- lapply(seq_len(k), function(index) {
    data.frame(
      time = object$time,
      mean = smat[, (index * 3) - 2],
      lower = smat[, (index * 3) - 1],
      upper = smat[, (index * 3)],
      type = paste0("Season, cycle=", cycles[index])
    )
  })
  season_frame <- do.call(rbind, season_frames)
  trend_frame <- data.frame(
    time = object$time,
    mean = object$trend$mean,
    lower = object$trend$lower,
    upper = object$trend$upper,
    type = "Trend"
  )
  plot_frame <- rbind(trend_frame, season_frame)

  ggplot2::ggplot(
    plot_frame,
    ggplot2::aes(
      x = time,
      y = mean
    )
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
    ggplot2::labs(
      x = "Time",
      y = ""
    ) +
    ggplot2::facet_grid(
      type ~ .,
      scales = "free_y"
    )
}

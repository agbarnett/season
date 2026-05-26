#' Plot the Results of a Cosinor
#'
#' `r lifecycle::badge("deprecated")` Soft-deprecated in favour of
#' [autoplot.Cosinor()], which returns a ggplot object you can extend with
#' `+`. The base R plot below still works.
#'
#' The code produces the fitted sinusoid based on the intercept and sinusoid.
#' The y-axis is on the scale of probability if the link function is
#' "logit" or "cloglog". If the analysis was based on monthly
#' data then month is shown on the x-axis. If the analysis was based on daily
#' data then time is shown on the x-axis.
#'
#' @param x a `Cosinor` object produced by [cosinor()]
#' @param \dots additional arguments passed to the sinusoid plot.
#' @returns connected line plot of fitted sinusoid object produced by [cosinor].
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [autoplot.Cosinor()], [cosinor()], [summary.Cosinor()],
#'   [seasrescheck()]
#' @examples
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
#' # Recommended:
#' autoplot(res)
#' # Still works, but deprecated:
#' plot(res)
#' @export
plot.Cosinor <- function(x, ...) {
  lifecycle::deprecate_warn(
    when = "0.3.17",
    what = "plot.Cosinor()",
    details = c(
      "Use `autoplot()` for a ggplot object you can extend:",
      i = "  autoplot(x) + ggplot2::theme_bw()"
    )
  )
  op <- par(no.readonly = TRUE) # the whole list of settable par's.
  on.exit(par(op), add = TRUE) # restore graphic settings
  f <- stats::as.formula(x$call$formula)
  parts <- paste(f)
  ylab <- parts[2]
  ## plot sinusoid ##
  time <- subset(x$glm$data, select = x$date)[, 1]
  o <- order(time)
  par(mai = c(0.8, 0.8, 0.1, 0.1)) # c(bottom, left, top, right)
  if (x$call$link != 'logit' && x$call$link != 'cloglog') {
    plot(
      time[o],
      x$fitted.values[o],
      type = 'l',
      xaxt = 'n',
      xlab = x$date,
      ylab = ylab,
      ...
    )
    if (x$type == 'monthly') {
      m.abb <- substr(month.abb, 1, 1)
      axis(side = 1, at = 1:12, labels = m.abb)
      points(time[o], x$fitted.values[o], pch = 19)
    }
    if (x$type == 'daily') {
      years <- as.numeric(names(table(format(time[o], '%Y'))))
      firsts <- as.numeric(ISOdate(month = 1, day = 1, year = years)) /
        (24 * 60 * 60)
      axis(side = 1, at = firsts, labels = years)
      rug(time[o])
    }
    if (x$type == 'hourly') {
      hours <- unique(as.numeric(format(time[o], '%H')))
      smonth <- as.numeric(format(time[1], '%m')) # starting month
      sday <- as.numeric(format(time[1], '%d')) # starting day
      syear <- as.numeric(format(time[1], '%Y')) # starting year
      firsts <- ISOdate(month = smonth, day = sday, year = syear, hour = hours)
      axis(side = 1, at = firsts, labels = hours)
      rug(time[o])
    }
  }
  if (x$call$link == 'logit' || x$call$link == 'cloglog') {
    ylab <- paste0('Probability(', ylab, ')')
    plot(
      x = time[o],
      y = x$fitted.values[o],
      type = 'l',
      xaxt = 'n',
      col = 'black',
      xlab = x$date,
      ylab = ylab,
      ...
    )
    if (x$type == 'monthly') {
      m.abb <- substr(month.abb, 1, 1)
      axis(side = 1, at = 1:12, labels = m.abb)
      points(time[o], x$fitted.values[o], pch = 19)
    }
    if (x$type == 'daily') {
      years <- as.numeric(names(table(format(time[o], '%Y'))))
      firsts <- as.numeric(ISOdate(month = 1, day = 1, year = years)) /
        (24 * 60 * 60)
      axis(side = 1, at = firsts, labels = years)
      rug(time[o])
    }
  }
}

#' Plot the fitted sinusoid from a [cosinor()] model
#'
#' Returns a ggplot of the fitted sinusoid. The y-axis is on the
#' probability scale for `logit` and `cloglog` link functions; the
#' x-axis switches between month, year, and hour depending on the
#' `type` of the model.
#'
#' @param object a `Cosinor` object produced by [cosinor()].
#' @param ... unused, for S3 generic compatibility.
#' @returns a ggplot object.
#' @author Nicholas Tierney
#' @seealso [cosinor()], [summary.Cosinor()], [seasrescheck()]
#' @examples
#' res <- cosinor(
#'   cvd ~ 1,
#'   date = "month",
#'   data = CVD,
#'   type = "monthly",
#'   family = poisson(),
#'   offsetmonth = TRUE
#' )
#' autoplot(res)
#' autoplot(res) + ggplot2::theme_minimal()
#' @export
autoplot.Cosinor <- function(object, ...) {
  check_if_cosinor(object)
  fitted <- NULL
  time <- object$glm$data[[object$date]]
  time_ordered <- order(time)
  dat <- data.frame(
    time = time[time_ordered],
    fitted = object$fitted.values[time_ordered]
  )

  on_prob_scale <- object$call$link %in% c("logit", "cloglog")
  ylab <- paste(object$call$formula)[2]
  if (on_prob_scale) {
    ylab <- paste0("Probability(", ylab, ")")
  }

  p <- ggplot2::ggplot(
    dat,
    ggplot2::aes(time, fitted)
  ) +
    ggplot2::geom_line() +
    ggplot2::labs(
      x = tools::toTitleCase(object$date),
      y = tools::toTitleCase(ylab)
    ) +
    ggplot2::theme_bw()

  p_time <- switch(
    object$type,
    monthly = p +
      ggplot2::geom_point() +
      ggplot2::scale_x_continuous(
        breaks = 1:12,
        labels = substr(month.abb, 1, 1)
      ),
    daily = p +
      ggplot2::scale_x_date(
        date_breaks = "1 year",
        date_labels = "%Y"
      ),
    hourly = p +
      ggplot2::scale_x_datetime(
        date_breaks = "1 hour",
        date_labels = "%H"
      ),
    p
  )

  p_time
}

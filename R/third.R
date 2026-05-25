#' Third-order Moment
#'
#' Estimated third order moment for a time series.
#'
#' The third-order moment is the extension of the second-order moment
#' (essentially the autocovariance). The equation for the third order moment at
#' lags (j,k) is: \eqn{n^{-1}\sum X_t X_{t+j} X_{t+k}}. The third-order moment
#' is useful for testing for non-linearity in a time series, and is used by
#' [nonlintest()].
#'
#' @param data a vector of equally spaced numeric observations (time series).
#' @param n.lag the number of lags, maximum = length of time series.
#' @param centre centre series by subtracting mean (default=TRUE).
#' @param outmax display the (x,y) lag co-ordinates for the maximum and minimum
#' values (default=TRUE).
#' @param plot `r lifecycle::badge("deprecated")` Use [autoplot.third()] on the
#'   returned object instead. See examples.
#' @returns an object of class `"third"` (a list) with the following elements:
#'   * waxis: the axis from `-n.lag` to `n.lag`.
#'   * third: the estimated third order moment in the range -n.lag to n.lag,
#'     including the symmetries.
#'   * n.lag: the maximum lag.
#'
#'   Pass the result to [autoplot()][autoplot.third()] to draw the contour
#'   plot.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [autoplot.third()]
#' @examples
#' \donttest{
#' t <- third(CVD$cvd, n.lag = 12)
#' autoplot(t)
#' }
#'
#' @export third
third <- function(
  data,
  n.lag,
  centre = TRUE,
  outmax = TRUE,
  plot = lifecycle::deprecated()
) {
  if (lifecycle::is_present(plot)) {
    lifecycle::deprecate_warn(
      when = "0.3.17",
      what = "third(plot)",
      details = c(
        "`third()` now returns a classed object you can pass to `autoplot()`.",
        i = "Use `autoplot(third(data, n.lag))` to draw the contour plot."
      )
    )
  } else {
    plot <- FALSE
  }

  n_sample <- length(data)
  if (n_sample < 10) {
    cli::cli_warn(
      c(
        "Sample size is small ({.code n = {n_sample}} < 10)",
        "Results may be unreliable."
      )
    )
  }
  # ------------ cumulants in non-redundant region -----------------
  XXX <- matrix(data = 0, n.lag + n.lag + 1, n.lag + n.lag + 1)
  if (centre) {
    centred <- data - mean(data)
  } else {
    centred <- data
  }
  for (d in 0:n.lag) {
    for (k in d:n.lag) {
      large <- max(c(d, k, 0))
      XXX[d + n.lag + 1, k + n.lag + 1] <- sum(
        centred[1:(n_sample - large)] *
          centred[(1 + d):(n_sample - large + d)] *
          centred[(1 + k):(n_sample - large + k)]
      ) /
        n_sample
      # Symmetry
      XXX[n.lag + 1 + k, n.lag + 1 + d] <- XXX[d + n.lag + 1, k + n.lag + 1]
      # Symmetry
      XXX[n.lag + 1 - d, n.lag + 1 + k - d] <- XXX[d + n.lag + 1, k + n.lag + 1]
      # Symmetry
      XXX[n.lag + 1 + k - d, n.lag + 1 - d] <- XXX[d + n.lag + 1, k + n.lag + 1]
      # Symmetry
      XXX[n.lag + 1 + d - k, n.lag + 1 - k] <- XXX[d + n.lag + 1, k + n.lag + 1]
      # Symmetry
      XXX[n.lag + 1 - k, n.lag + 1 + d - k] <- XXX[d + n.lag + 1, k + n.lag + 1]
    }
  }

  waxis <- -n.lag:n.lag

  # Lags of minima and maxima
  if (outmax) {
    max_idx <- which(XXX == max(XXX), arr.ind = TRUE) - n.lag - 1
    min_idx <- which(XXX == min(XXX), arr.ind = TRUE) - n.lag - 1
    cli::cli_inform(c(
      "Maximum at (including symmetries):",
      " " = "{paste(max_idx, collapse = ' ')}",
      "Minimum at (including symmetries):",
      " " = "{paste(min_idx, collapse = ' ')}"
    ))
  }

  result <- list(
    waxis = waxis,
    third = XXX,
    n.lag = n.lag
  )
  class(result) <- c("third", "list")

  ## Deprecated side-effect: still respect `plot = TRUE` if user passed it
  if (isTRUE(plot)) {
    print(autoplot(result))
  }

  result
}

#' Plot the third-order moment from [third()]
#'
#' Produce a ggplot contour of the third-order moment over its
#' non-redundant region.
#'
#' @param object a `"third"` object produced by [third()].
#' @param ... unused, for S3 generic compatibility.
#' @returns a ggplot contour plot.
#' @author Nicholas Tierney
#' @seealso [third()]
#' @examples
#' \donttest{
#' t <- third(CVD$cvd, n.lag = 4)
#' autoplot(t)
#' }
#' @export
autoplot.third <- function(object, ...) {
  k <- d <- NULL
  check_if_third(object)
  xaxis <- yaxis <- zaxis <- NULL
  XXX <- object$third
  n_lag <- object$n.lag
  coords <- expand.grid(d = 0:n_lag, k = 0:n_lag) |>
    subset(subset = k >= d)
  dat <- data.frame(
    xaxis = coords$d,
    yaxis = coords$k,
    zaxis = XXX[cbind(coords$d + n_lag + 1, coords$k + n_lag + 1)]
  )
  ggplot2::ggplot(
    dat,
    ggplot2::aes(
      x = xaxis,
      y = yaxis,
      z = zaxis
    )
  ) +
    ggplot2::geom_tile(ggplot2::aes(
      fill = zaxis
    )) +
    ggplot2::stat_contour()
}

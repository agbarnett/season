## third.R
## estimate the third order moment
## Jan 2014
# inputs
#       data       - time-series
#       n.lag    - number of lags, max = length of time series
#       centre	  - centre series by subtracting mean (TRUE/FALSE)
#       outmax  - display lags of maxima and minima (TRUE/FALSE)
#       plot  - ggplot plot of the third order moment (TRUE/FALSE)

#' Third-order Moment
#'
#' Estimated third order moment for a time series.
#'
#' The third-order moment is the extension of the second-order moment
#' (essentially the autocovariance). The equation for the third order moment at
#' lags (j,k) is: \eqn{n^{-1}\sum X_t X_{t+j} X_{t+k}}. The third-order moment
#' is useful for testing for non-linearity in a time series, and is used by
#' `nonlintest`.
#'
#' @param data a vector of equally spaced numeric observations (time series).
#' @param n.lag the number of lags, maximum = length of time series.
#' @param centre centre series by subtracting mean (default=TRUE).
#' @param outmax display the (x,y) lag co-ordinates for the maximum and minimum
#' values (default=TRUE).
#' @param plot contour plot of the third order moment (default=TRUE).
#' @return a list with the following elements:
#'   * waxis: the axis from `-n.lag` to `n.lag`.
#'   * third: the estimated third order moment in the range -n.lag to n.lag,
#'     including the symmetries.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#'
#' data(CVD)
#' third(CVD$cvd, n.lag=12)
#'
#' @export third
third = function(data, n.lag, centre = TRUE, outmax = TRUE, plot = TRUE) {
  xaxis <- yaxis <- zaxis <- NULL # Setting some variables to NULL first (for R CMD check)

  nsamp = length(data)
  if (nsamp < 10) {
    cat('warning n<10\n')
  }
  # ---------------- cumulants in non-redundant region -----------------
  XXX = matrix(data = 0, n.lag + n.lag + 1, n.lag + n.lag + 1)
  if (centre == TRUE) {
    centred = data - mean(data)
  } else {
    centred = data
  }
  if (plot == TRUE) {
    count = 0
  }
  for (d in 0:n.lag) {
    for (k in d:n.lag) {
      large = max(c(d, k, 0))
      XXX[d + n.lag + 1, k + n.lag + 1] = sum(
        centred[1:(nsamp - large)] *
          centred[(1 + d):(nsamp - large + d)] *
          centred[(1 + k):(nsamp - large + k)]
      ) /
        nsamp
      XXX[n.lag + 1 + k, n.lag + 1 + d] = XXX[d + n.lag + 1, k + n.lag + 1] # Symmetry
      XXX[n.lag + 1 - d, n.lag + 1 + k - d] = XXX[d + n.lag + 1, k + n.lag + 1] # Symmetry
      XXX[n.lag + 1 + k - d, n.lag + 1 - d] = XXX[d + n.lag + 1, k + n.lag + 1] # Symmetry
      XXX[n.lag + 1 + d - k, n.lag + 1 - k] = XXX[d + n.lag + 1, k + n.lag + 1] # Symmetry
      XXX[n.lag + 1 - k, n.lag + 1 + d - k] = XXX[d + n.lag + 1, k + n.lag + 1] # Symmetry
      if (plot == TRUE) {
        frame = data.frame(
          xaxis = d,
          yaxis = k,
          zaxis = XXX[d + n.lag + 1, k + n.lag + 1]
        )
        if (count == 0) {
          for.plot = frame
        } else {
          for.plot = rbind(for.plot, frame)
        }
        count = count + 1
      }
    }
  }

  waxis = -n.lag:n.lag

  # Lags of minima and maxima
  if (outmax == TRUE) {
    cat('Maximum at (including symmetries)\n')
    cat(which(XXX == max(XXX), arr.ind = T) - n.lag - 1, '\n')
    cat('Minimum at (including symmetries)\n')
    cat(which(XXX == min(XXX), arr.ind = T) - n.lag - 1, '\n')
  }

  # Lags of minima and maxima
  if (plot == TRUE) {
    gplot = ggplot2::ggplot(
      for.plot,
      ggplot2::aes(
        xaxis,
        yaxis,
        z = zaxis
      )
    ) +
      ggplot2::stat_contour() +
      ggplot2::geom_tile(ggplot2::aes(fill = zaxis))
    print(gplot)
  }

  to.return = list()
  to.return$waxis = waxis
  to.return$third = XXX
  return(to.return)
} # end of function

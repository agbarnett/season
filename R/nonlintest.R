#' Test of Non-linearity of a Time Series
#'
#' A bootstrap test of non-linearity in a time series using the third-order
#' moment.
#'
#' The test uses `aaft` to create linear surrogates with the same
#' second-order properties, but no (third-order) non-linearity. The third-order
#' moments (`third`) of these linear surrogates and the actual series are
#' then compared from lags 0 up to `n.lag` (excluding the skew at the
#' co-ordinates (0,0)). The bootstrap test works on the overall area outside
#' the limits, and gives an indication of the overall non-linearity. The plot
#' using `region` shows those co-ordinates of the third order moment that
#' exceed the null hypothesis limits, and can be a useful clue for guessing the
#' type of non-linearity. For example, a large value at the co-ordinates (0,1)
#' might be caused by a bi-linear series \eqn{X_t=\alpha
#' X_{t-1}\varepsilon_{t-1} +\varepsilon_t}.
#'
#' @param data a vector of equally spaced numeric observations (time series).
#' @param n.lag the number of lags tested using the third-order moment, maximum
#' = length of time series.
#' @param n.boot the number of bootstrap replications (suggested minimum of
#' 100; 1000 or more would be better).
#' @param alpha statistical significance level of test (default=0.05).
#' @returns Returns an object of class "nonlintest" with the following
#' parts:
#'   * region: the region of the third order moment where the test exceeds
#'     the limits (up to `n.lag`).
#'   * n.lag: the maximum lag tested using the third-order moment.
#'   * stats: a list of statistics for the area outside the test limits:
#'     * outside: the total area outside of limits (summed over the whole
#'       third-order moment).
#'     * stan: the total area outside the limits divided by its standard
#'       deviation to give a standardised estimate.
#'     * median: the median area outside the test limits.
#'     * upper: the (1-`alpha`)th percentile of the area outside the limits.
#'     * pvalue: bootstrap p-value of the area outside the limits to test
#'       if the series is linear.
#'     * test: reject the null hypothesis that the series is linear
#'       (TRUE/FALSE).
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [print.nonlintest()] [plot.nonlintest()]
#' @references Barnett AG & Wolff RC (2005) A Time-Domain Test for Some Types
#' of Nonlinearity, *IEEE Transactions on Signal Processing*, vol 53,
#' pages 26--33 \doi{doi: 10.1109/TSP.2004.838942}.
#' @examples
#' \donttest{
#' \dontrun{
#' test.res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 1000)
#' }
#' }
#'
#' @export
nonlintest <- function(data, n.lag, n.boot, alpha = 0.05) {
  x_diff <- data - mean(data)

  reglags <- (n.lag + 1):(n.lag + n.lag + 1)

  x_third <- third(
    data = x_diff,
    n.lag = n.lag,
    centre = FALSE,
    outmax = FALSE,
    plot = FALSE
  )$third[reglags, reglags]

  x_third[1, 1] <- 0

  # Get n.boot*3 surrogates using the AAFT method
  # First n.boot for initial limits 2nd & 3rd n.boot for bootstrap limits
  aaft_sers <- aaft(x_diff, nsur = n.boot * 3)

  # Run each series through the third order moment;
  aaft_third <- vapply(
    X = seq_len(n.boot * 3),
    FUN = function(x) {
      third(
        aaft_sers[, x],
        n.lag,
        centre = FALSE,
        outmax = FALSE,
        plot = FALSE
      )$third[reglags, reglags]
    },
    FUN.VALUE = array(0, dim = c(n.lag + 1, n.lag + 1))
  )

  aaft_third[1, 1, ] <- 0 # Remove skewness;

  # Get (1-alpha)th centile at each coordinate and difference from the series;
  centile_lower <- alpha / 2
  centile_upper <- 1 - (alpha / 2)
  centile_l1 <- matrix(0, n.lag + 1, n.lag + 1)
  centile_u1 <- matrix(0, n.lag + 1, n.lag + 1)
  centile_l2 <- matrix(0, n.lag + 1, n.lag + 1)
  centile_u2 <- matrix(0, n.lag + 1, n.lag + 1)
  for (r in 0:n.lag) {
    for (s in r:n.lag) {
      if ((r + s) > 0) {
        # First limits
        pts1 <- aaft_third[r + 1, s + 1, 1:n.boot]
        centile_l1[r + 1, s + 1] <- quantile_dbl(pts1, probs = centile_lower)
        centile_u1[r + 1, s + 1] <- quantile_dbl(pts1, probs = centile_upper)

        # Second limits
        pts2 <- aaft_third[r + 1, s + 1, (n.boot + 1):(2 * n.boot)]
        centile_l2[r + 1, s + 1] <- quantile_dbl(pts2, probs = centile_lower)
        centile_u2[r + 1, s + 1] <- quantile_dbl(pts2, probs = centile_upper)
      }
    }
  }
  upper_tri <- upper.tri(matrix(0, n.lag + 1, n.lag + 1), diag = TRUE)
  # Just get for s<r;
  diff_lower <- (x_third - centile_l1) * upper_tri
  # Just get for s<r;
  diff_upper <- (x_third - centile_u1) * upper_tri

  # Show points significantly higher or lower than limits;
  region_upper <- matrix(0, n.lag + 1, n.lag + 1)
  region_lower <- matrix(0, n.lag + 1, n.lag + 1)
  index <- diff_upper > 0
  region_upper[index] <- diff_upper[index]
  index <- diff_lower < 0
  region_lower[index] <- diff_lower[index]
  region <- region_upper + region_lower
  # Total area exceeding limits;
  outside <- sum(sum(abs(region)))
  #total=((n.lag+1)*(n.lag+2)/2)-1; # Total number of points tested

  # Double bootstrap statistic using 2nd set of limits on first set of data;
  # 3rd series - limits from 2nd;
  jackstat <- vector(mode = 'numeric', length = n.boot)
  for (jack in ((2 * n.boot) + 1):(n.boot * 3)) {
    ## Percentile statistic;
    diffjack_upper <- (aaft_third[,, jack] - centile_u2) * upper_tri
    diffjack_lower <- (aaft_third[,, jack] - centile_l2) * upper_tri
    jregion_upper <- matrix(0, n.lag + 1, n.lag + 1)
    jregion_lower <- matrix(0, n.lag + 1, n.lag + 1)
    jindex <- diffjack_upper > 0
    jregion_upper[jindex] <- diffjack_upper[jindex]
    jindex <- diffjack_lower < 0
    jregion_lower[jindex] <- diffjack_lower[jindex]
    jregion <- jregion_upper + jregion_lower
    # Total area exceeding limits;
    jackstat[jack - (2 * n.boot)] <- sum(sum(abs(jregion)))
  }

  jack_std <- stats::sd(jackstat)
  stan <- outside / jack_std
  jack_upper <- stats::quantile(jackstat, probs = 1 - alpha)
  jack_median <- stats::median(jackstat)
  jack_p <- sum(outside < jackstat) / n.boot

  # return stats and plot details
  testjack <- as.logical(outside > jack_upper)

  jackstats <- list(
    outside = outside,
    stan = stan,
    median = jack_median,
    upper = jack_upper,
    pvalue = jack_p,
    test = testjack
  )

  results <- list(
    stats = jackstats,
    region = region,
    diff_l = diff_lower,
    diff_u = diff_upper,
    n.lag = n.lag
  )

  class(results) <- c('nonlintest', class(results))

  results
}

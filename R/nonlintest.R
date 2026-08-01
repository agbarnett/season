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
#' test_res <- nonlintest(data = CVD$cvd, n.lag = 4, n.boot = 1000)
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
    outmax = FALSE
  )$third[reglags, reglags]

  x_third[1, 1] <- 0

  # Get n.boot*3 surrogates using the AAFT method
  # First n.boot for initial limits 2nd & 3rd n.boot for bootstrap limits
  # Run each series through the third order moment;
  aaft_third <- aaft_third(
    x_diff = x_diff,
    n.boot = n.boot,
    n.lag = n.lag,
    reglags = reglags
  )

  # Get (1-alpha)th centile at each coordinate, then difference from the series;
  centile_1 <- aaft_centile(
    lower = alpha / 2,
    upper = 1 - (alpha / 2),
    n.lag = n.lag,
    aaft_third = aaft_third,
    third_idx = 1:n.boot
  )

  centile_2 <- aaft_centile(
    lower = alpha / 2,
    upper = 1 - (alpha / 2),
    n.lag = n.lag,
    aaft_third = aaft_third,
    third_idx = (n.boot + 1):(2 * n.boot)
  )

  upper_tri <- upper.tri(matrix(0, n.lag + 1, n.lag + 1), diag = TRUE)
  centile_diff <- centile_diffs(
    upper_tri = upper_tri,
    x_third = x_third,
    centile = centile_1
  )

  region <- calculate_region(
    n.lag = n.lag,
    centile_diff = centile_diff
  )

  # Total area exceeding limits;
  outside <- sum(sum(abs(region)))
  #total=((n.lag+1)*(n.lag+2)/2)-1; # Total number of points tested

  # Double bootstrap statistic using 2nd set of limits on first set of data;
  # 3rd series - limits from 2nd;
  jackstat <- jack_bootstrap(
    n.boot = n.boot,
    n.lag = n.lag,
    aaft_third = aaft_third,
    centile_2 = centile_2
  )

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
    diff_l = centile_diff$lower,
    diff_u = centile_diff$upper,
    n.lag = n.lag
  )

  class(results) <- c('nonlintest', class(results))

  results
}

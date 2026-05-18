#' Mean and Confidence Interval for Circular Phase
#'
#' Calculates the mean and confidence interval for the phase based on a chain
#' of MCMC samples.
#'
#' The estimates of the phase are rotated to have a centre of \eqn{\pi}, the
#' point on the circumference of a unit radius circle that is furthest from
#' zero. The mean and confidence interval are calculated on the rotated values,
#' then the estimates are rotated back.
#'
#' @param theta chain of Markov chain Monte Carlo (MCMC) samples of the phase.
#' @param alpha the confidence level (default = 0.05 for a 95\% confidence
#' interval).
#' @returns a list with the following elements:
#'   * mean: the estimated mean phase.
#'   * lower: the estimated lower limit of the confidence interval.
#'   * upper: the estimated upper limit of the confidence interval.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Fisher, N. (1993) *Statistical Analysis of Circular Data*.
#' Cambridge University Press. Page 36.
#'
#' Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal Health Data*.
#'   Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' \donttest{
#' # 2000 normal samples, centred on zero
#' theta <- rnorm(n = 2000, mean = 0, sd = pi / 50)
#' hist(theta, breaks = seq(-pi / 8, pi / 8, pi / 30))
#' ciPhase(theta)
#' }
#'
#' @export
ciPhase <- function(theta, alpha = 0.05) {
  # proposed centres
  theta_c <- seq(
    from = 0,
    to = 2 * pi,
    by = pi / 100
  )
  m <- length(theta_c)
  d_theta <- vector(length = m, mode = 'numeric')
  for (i in 1:m) {
    # Fisher page 36
    d_theta[i] <- pi - mean(abs(pi - abs(theta - theta_c[i])))
  }
  centre <- theta_c[d_theta == min(d_theta)]
  if (length(centre) > 1) {
    centre <- centre[1]
  }
  # rotate data to be centred on pi
  # only rotate if centre is in top-half of the circle
  ideal <- theta
  diff <- 0
  theta_in_top_half <- centre < pi / 2 || centre > 3 * pi / 2
  if (theta_in_top_half) {
    diff <- pi - centre
    diff_neg <- (-2 * pi) + diff
    ideal <- theta + diff * (theta < pi) + diff_neg * (theta > pi)
  }

  result <- list(
    mean = mean(ideal) - diff,
    lower = quantile_dbl(ideal, probs = alpha / 2) - diff,
    upper = quantile_dbl(ideal, probs = 1 - (alpha / 2)) - diff
  )

  result
}

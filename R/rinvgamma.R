# rinvgamma.R from MCMCpack
#' Random Inverse Gamma Distribution
#'
#' Internal function to simulate a value from an inverse Gamma distribution,
#' used by [nscosinor()]. See the [MCMCpack::rinvgamma()]. For internal use only.
#'
#' @param n number of observations.
#' @param shape Gamma shape parameter.
#' @param scale Gamma scale parameter (default=1).
#' @returns simulated value from inverse Gamma distribution.
#' @noRd
#' @note internal
rinvgamma <- function(n, shape, scale = 1) {
  return(1 / stats::rgamma(n, shape, scale))
}

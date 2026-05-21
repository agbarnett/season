#' Summary for a Non-stationary Cosinor
#'
#' The default summary method for a `nsCosinor` object produced by
#' [nscosinor()].
#'
#' The amplitude describes the average height of each seasonal cycle, and the
#' phase describes the location of the peak. The results for the phase are
#' given in radians (0 to 2\eqn{\pi}), they can be transformed to the time
#' scale using the [invyrfraction()] making sure to first divide by
#' 2\eqn{\pi}.
#'
#' The larger the standard deviation for the seasonal cycles, the greater the
#' non-stationarity. This is because a larger standard deviation means more
#' change over time.
#'
#' @aliases summary.nsCosinor
#' @param object a `nsCosinor` object produced by [nscosinor()].
#' @param \dots further arguments passed to or from other methods.
#' @returns a list with the following elements:
#'   * cycles: vector of cycles in units of time, e.g., for a six and twelve
#'     month pattern `cycles=c(6,12)`.
#'   * niters: total number of MCMC samples.
#'   * burnin: number of MCMC samples discarded as a burn-in.
#'   * tau: vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for
#'     1st seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc.
#'   * stats: summary statistics (mean and confidence interval) for the
#'     residual standard deviation, the standard deviation for each seasonal
#'     cycle, and the amplitude and phase for each cycle.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [nscosinor()] [plot.nsCosinor()]
#' @examples
#' \donttest{
#' # model to fit an annual pattern to the monthly cardiovascular disease data
#' f <- c(12)
#' tau <- c(10,50)
#' \dontrun{
#'   res12 <- nscosinor(
#'     data = CVD,
#'     response = 'adj',
#'     cycles = f,
#'     niters = 5000,
#'     burnin = 1000,
#'     tau = tau
#'     )
#' summary(res12)
#' plot(res12)
#' }
#' }
#' @export
summary.nsCosinor <- function(object, ...) {
  check_if_nscosinor(object)
  k <- length(object$cycles)

  errorstats <- mcmc_summary_stats(object$chains[, 1])

  wstats <- matrix(
    NA_real_,
    nrow = k,
    ncol = 3,
    dimnames = list(NULL, c("mean", "lower", "upper"))
  )
  ampstats <- wstats
  phasestats <- wstats

  for (j in seq_len(k)) {
    wstats[j, ] <- mcmc_summary_stats(object$chains[, 1 + j])
    ampstats[j, ] <- mcmc_summary_stats(object$chains[, 1 + 2 * k + j])
    pstat <- ciPhase(as.vector(object$chains[, 1 + k + j]))
    phasestats[j, ] <- c(pstat$mean, pstat$lower, pstat$upper)
  }

  result <- list(
    cycles = object$cycles,
    niters = object$call$niters,
    burnin = object$call$burnin,
    tau = object$call$tau,
    stats = list(
      errorstats = errorstats,
      wstats = wstats,
      ampstats = ampstats,
      phasestats = phasestats
    )
  )
  class(result) <- c("summary.nsCosinor", class(result))
  result
}

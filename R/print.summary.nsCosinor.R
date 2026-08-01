#' Print a summary of an [nscosinor()] object
#'
#' @param \dots further arguments passed to or from other methods.
#' @param x a `summary.nsCosinor` object produced by [summary.nsCosinor()].
#' @returns summary - Statistics for non-stationary cosinor based on MCMC
#'   chains.
#' @export
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
#'     niters = 200,
#'     burnin = 100,
#'     tau = tau
#'     )
#' summary(res12)
#' }
#' }
print.summary.nsCosinor <- function(x, ...) {
  check_if_class(x, "summary.nsCosinor")
  k <- length(x$cycles)
  cat("Statistics for non-stationary cosinor based on MCMC chains\n")
  cat("Number of MCMC samples = ", x$niters - x$burnin + 1, "\n", sep = "")
  cat("\nStandard deviations\n")
  cat(sprintf(
    "Residual, mean=%g, 95%% CI [%g, %g]\n",
    x$stats$errorstats[1],
    x$stats$errorstats[2],
    x$stats$errorstats[3]
  ))
  for (j in seq_len(k)) {
    cat(sprintf("Cycle=%g\n", x$cycles[j]))
    cat(sprintf(
      "Season, mean=%g, 95%% CI [%g, %g]\n",
      x$stats$wstats[j, 1],
      x$stats$wstats[j, 2],
      x$stats$wstats[j, 3]
    ))
  }
  cat("\nPhase and amplitude\n")
  for (j in seq_len(k)) {
    cat(sprintf("Cycle=%g\n", x$cycles[j]))
    cat(sprintf(
      "Amplitude, mean=%g, 95%% CI [%g, %g]\n",
      x$stats$ampstats[j, 1],
      x$stats$ampstats[j, 2],
      x$stats$ampstats[j, 3]
    ))
    cat(sprintf(
      "Phase (radians), mean=%g, 95%% CI [%g, %g]\n",
      x$stats$phasestats[j, 1],
      x$stats$phasestats[j, 2],
      x$stats$phasestats[j, 3]
    ))
  }
  invisible(x)
}

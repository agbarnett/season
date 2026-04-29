## print.nsCosinor.R
## Prints basic results from nsCosinor

#' Print the Results of a Non-stationary Cosinor
#'
#' The default print method for a `nsCosinor` object produced by
#' `nscosinor`.
#'
#' Prints out the model call, number of MCMC samples, sample size and residual
#' summary statistics.
#'
#' @param x a `nsCosinor` object produced by `nscosinor`.
#' @param \dots further arguments passed to or from other methods.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `nscosinor`, `summary.nsCosinor`
#' @export
print.nsCosinor <- function(x, ...) {
  ## Checks
  if (!inherits(x, "nsCosinor")) {
    stop("Object must be of class 'nsCosinor'")
  }

  ## Statistics ###
  cat("Non-stationary cosinor\n\n")
  cat("Call:\n")
  print(x$call)
  cat(
    "\nNumber of MCMC samples = ",
    x$call$niters - x$call$burnin + 1,
    "\n\n",
    sep = ""
  )
  cat("Length of time series = ", x$n, "\n", sep = "")
  cat("\nResidual statistics\n", sep = "")
  print(summary(x$residuals), ...)
} # end of function

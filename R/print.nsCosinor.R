## print.nsCosinor.R
## Prints basic results from nsCosinor



#' Print the Results of a Non-stationary Cosinor
#' 
#' The default print method for a \code{nsCosinor} object produced by
#' \code{nscosinor}.
#' 
#' Prints out the model call, number of MCMC samples, sample size and residual
#' summary statistics.
#' 
#' @param x a \code{nsCosinor} object produced by \code{nscosinor}.
#' @param \dots further arguments passed to or from other methods.
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{nscosinor}, \code{summary.nsCosinor}
#' @export 
print.nsCosinor<-function(x, ...){

  ## Checks
  if (class(x)!="nsCosinor"){
    stop("Object must be of class 'nsCosinor'")} 

  ## Statistics ###
  cat("Non-stationary cosinor\n\n")
  cat("Call:\n")
  print(x$call)
  cat("\nNumber of MCMC samples = ",x$call$niters-x$call$burnin+1,
      "\n\n",sep="")
  cat("Length of time series = ",x$n,"\n",sep="")
  cat("\nResidual statistics\n",sep="")
  print(summary(x$residuals), ...)
} # end of function

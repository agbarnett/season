## print.Cosinor.R
## Prints basic results from Cosinor



#' Print the Results of a Cosinor
#' 
#' The default print method for a \code{Cosinor} object produced by
#' \code{cosinor}.
#' 
#' Uses \code{print.glm}.
#' 
#' @param x a \code{Cosinor} object produced by \code{cosinor}.
#' @param \dots optional arguments to \code{print} or \code{plot} methods.
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{cosinor}, \code{summary.Cosinor}, \code{glm}
#' @export 
print.Cosinor<-function(x, ...){

  ## Checks
  if (class(x)!="Cosinor"){stop("Object must be of class 'Cosinor'")} 

  ## Use GLM function ###
  print(x$glm, ...)
} # end of function

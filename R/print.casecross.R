## print.casecross.R
## Prints basic results from casecross
## Oct 2009


#' Print the Results of a Case-Crossover Model
#' 
#' The default print method for a \code{casecross} object produced by
#' \code{casecross}.
#' 
#' Uses \code{print.coxph}.
#' 
#' @param x a \code{casecross} object produced by \code{casecross}.
#' @param \dots optional arguments to \code{print} or \code{plot} methods.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{casecross}, \code{summary.casecross}, \code{coxph}
#' @export 
print.casecross<-function(x, ...){
## Check
  if (class(x) != "casecross"){
    stop("Object must be of class 'casecross'")
  } 
## Use print.coxph
  if (class(x$c.model) != "coxph"){
    stop("Conditional logistic regression model object 'c.model' must be of class 'coxph'")
  }    
  print(x$c.model, ...)
} # end of function

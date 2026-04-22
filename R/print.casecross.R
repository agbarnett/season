## print.casecross.R
## Prints basic results from casecross
## Oct 2009


#' Print the Results of a Case-Crossover Model
#' 
#' The default print method for a `casecross` object produced by
#' `casecross`.
#' 
#' Uses `print.coxph`.
#' 
#' @param x a `casecross` object produced by `casecross`.
#' @param \dots optional arguments to `print` or `plot` methods.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `casecross`, `summary.casecross`, `coxph`
#' @export 
print.casecross<-function(x, ...){
## Check
  if (!inherits(x, "casecross")){
    stop("Object must be of class 'casecross'")
  } 
## Use print.coxph
  if (!inherits(x$c.model, "coxph")){
    stop("Conditional logistic regression model object 'c.model' must be of class 'coxph'")
  }    
  print(x$c.model, ...)
} # end of function

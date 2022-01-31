## print.monthglm.R
## Prints basic results from monthglm


#' Print \code{monthglm}
#' 
#' @param x Object of class \code{monthglm}
#' @param ... further arguments passed to or from other methods. 
#'
#' @export
print.monthglm<-function(x, ...){
  ## Checks
  if (class(x)!="monthglm"){stop("Object must be of class 'monthglm'")} 
  ## Use GLM function ###
  print(x$glm, ...)
} # end of function


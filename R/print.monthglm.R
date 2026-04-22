## print.monthglm.R
## Prints basic results from monthglm


#' Print `monthglm`
#' 
#' @param x Object of class `monthglm`
#' @param ... further arguments passed to or from other methods. 
#'
#' @export
print.monthglm<-function(x, ...){
  ## Checks
  if (!inherits(x,"monthglm")){stop("Object must be of class 'monthglm'")} 
  ## Use GLM function ###
  print(x$glm, ...)
} # end of function


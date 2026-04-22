## print.Monthmean.R
## Prints basic results from monthmean
## Oct 2009


#' Print the Results from Monthmean
#' 
#' Print the monthly means from a `Monthmean` object produced by
#' `monthmean`.
#' 
#' The code prints the monthly mean estimates.
#' 
#' @param x a `Monthmean` object produced by `monthmean`.
#' @inheritParams summary.Cosinor
#' @param \dots additional arguments passed to the print.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso `monthmean`
#' @export 
print.Monthmean<-function(x, digits=1, ...){
## Check
  if (!inherits(x, "Monthmean")){
    stop("Object must be of class 'Monthmean'")
  } 
## Print
  toprint<-as.data.frame(cbind(month.name,round(x$mean,digits)))
  names(toprint)<-c('Month','Mean')
  print(toprint,row.names=F, ...)
} # end of function

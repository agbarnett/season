## print.Monthmean.R
## Prints basic results from monthmean
## Oct 2009


#' Print the Results from Monthmean
#' 
#' Print the monthly means from a \code{Monthmean} object produced by
#' \code{monthmean}.
#' 
#' The code prints the monthly mean estimates.
#' 
#' @param x a \code{Monthmean} object produced by \code{monthmean}.
#' @param digits minimal number of significant digits, see \code{print.default}
#' @param \dots additional arguments passed to the print.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{monthmean}
#' @export 
print.Monthmean<-function(x, digits=1, ...){
## Check
  if (class(x) != "Monthmean"){
    stop("Object must be of class 'Monthmean'")
  } 
## Print
  toprint<-as.data.frame(cbind(month.name,round(x$mean,digits)))
  names(toprint)<-c('Month','Mean')
  print(toprint,row.names=F, ...)
} # end of function

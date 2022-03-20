## summary.casecross.R
## Summarise results from casecross
## Oct 2011


#' Summary of the Results of a Case-crossover Model
#' 
#' The default summary method for a \code{casecross} object produced by
#' \code{casecross}.
#' 
#' Shows the number of control days, the average number of control days per
#' case days, and the parameter estimates.
#' 
#' @param object a \code{casecross} object produced by \code{casecross}.
#' @param \dots further arguments passed to or from other methods.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{casecross}
#' @export 
summary.casecross<-function(object, ...){

  ## Check
  if (class(object)!="casecross"){stop("Object must be of class 'casecross'")} 

  ## output results
  if(object$call$stratamonth==FALSE){cat('Time-stratified case-crossover with a stratum length of',
      object$call$stratalength,'days\n')}
  if(object$call$stratamonth!=FALSE){cat('Time-stratified case-crossover with months as strata\n')} # Added Oct 2011
  if(object$call$matchdow==TRUE){cat('Matched on day of the week\n')}
  if(object$call$matchconf!=''){
    cat('Matched on',object$call$matchconf,'plus/minus',
        object$call$confrange,'\n')
  }
  cat('Total number of cases',object$ncases,'\n')
  cat('Number of case days with available control days',object$ncasedays,'\n')
  cat('Average number of control days per case day',object$ncontroldays,'\n')
  cat('\nParameter Estimates:\n')
  s<-summary(object$c.model)
  print(s$coef, ...)
}

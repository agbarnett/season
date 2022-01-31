#' Summary for a Monthglm
#' 
#' The default summary method for a \code{monthglm} object produced by
#' \code{monthglm}.
#' 
#' The estimates are the mean, 95\% confidence interval, Z-value and associated
#' p-value (comparing each month to the reference month). If Poisson regression
#' was used then the estimates are shown as rate ratios. If logistic regression
#' was used then the estimates are shown as odds ratios.
#' 
#' @aliases summary.monthglm 
#' @param object a \code{monthglm} object produced by \code{nscosinor}.
#' @param \dots further arguments passed to or from other methods.
#' @return \item{n}{sample size.} \item{month.ests}{parameter estimates for the
#' intercept and months.} \item{month.effect}{scale of the monthly effects.
#' \sQuote{RR} for \sQuote{rate ratios}, \sQuote{OR} for \sQuote{odds ratios},
#' or empty otherwise.} \item{x}{object of class \code{monthglm}}
#' \item{object}{object of class \code{monthglm}} \item{list()}{further
#' arguments passed to or from other methods.}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{monthglm}, \code{plot.monthglm}
#' @export
summary.monthglm<-function(object, ...){
  if (class(object)!="monthglm"){stop("Object must be of class 'monthglm'")} 
## Tabulate the monthly data ##
  z<-qnorm(0.975)
  s<-summary(object$glm)
  type<-as.character(object$call$family)[1]
  out<-as.data.frame(matrix(data=NA,nrow=nrow(s$coef),ncol=5))
  names(out)<-c('mean','lower','upper','zvalue','pvalue')
  row.names(out)<-row.names(s$coef)
  out$mean<-s$coef[,1]
  out$lower<-s$coef[,1]-(z*s$coef[,2])
  out$upper<-s$coef[,1]+(z*s$coef[,2])
  out$zvalue<-s$coef[,3]
  out$pvalue<-s$coef[,4]
# Exponentiate the results if rate or odds ratio
  if (type=="poisson"|type=="binomial"){
     out$mean<-exp(out$mean)
     out$lower<-exp(out$lower)
     out$upper<-exp(out$upper)
  }
# Just keep results with months
  index<-grep("months",row.names(out),ignore.case=TRUE,value=FALSE)
  totable<-out[index,] # Select months
  effect<-''
  if (type=="poisson"){effect='RR'}
  if (type=="binomial"){effect='OR'}
# returns
 ret<-list()
 ret$n=length(object$residuals)
 ret$month.ests=totable
 ret$month.effect=effect
 class(ret) <- "summary.monthglm"
 ret # uses print.summary.monthglm
}

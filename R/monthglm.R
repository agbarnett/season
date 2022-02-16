## monthglm.R
## fit a GLM using month as a factor
## option to add offset to control for uneven number of days
## Jan 2014



#' Fit a GLM with Month
#' 
#' Fit a generalized linear model with a categorical variable of month.
#' 
#' Month is fitted as a categorical variable as part of a generalized linear
#' model. Other independent variables can be added to the right-hand side of
#' \code{formula}.
#' 
#' This model is useful for examining non-sinusoidal seasonal patterns. For
#' sinusoidal seasonal patterns see \code{\link{cosinor}}.
#' 
#' The data frame should contain the integer months and the year as a 4 digit
#' number. These are used to calculate the number of days in each month
#' accounting for leap years.
#' 
#' @param formula regression model formula, e.g., \code{y~x1+x2}, (do not add
#' month to the regression equation, it will be added automatically).
#' @param data a data frame.
#' @param family a description of the error distribution and link function to
#' be used in the model (default=\code{gaussian()}). (See \code{\link{family}}
#' for details of family functions.).
#' @param refmonth reference month, must be between 1 and 12 (default=1 for
#' January).
#' @param monthvar name of the month variable which is either an integer (1 to
#' 12) or a character or factor (`Jan' to `Dec' or `January' to `December')
#' (default='month').
#' @param offsetmonth include an offset to account for the uneven number of
#' days in the month (TRUE/FALSE). Should be used for monthly counts (with
#' \code{family=poisson()}).
#' @param offsetpop include an offset for the population (optional), this
#' should be a variable in the data frame. Do not log-transform the offset as
#' the log-transform is applied by the function.
#' @return \item{call}{the original call to the monthglm function.}
#' \item{fit}{GLM model.} \item{fitted}{fitted values.}
#' \item{residuals}{residuals.} \item{out}{details on the monthly estimates.}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{summary.monthglm}, \code{plot.monthglm}
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @examples
#' 
#' data(CVD)
#' mmodel = monthglm(formula=cvd~1 ,data=CVD, family=poisson(),
#'                   offsetpop=expression(pop/100000), offsetmonth=TRUE)
#' summary(mmodel)
#' 
#' @export monthglm
monthglm<-function(formula,data,family=gaussian(),refmonth=1,
                   monthvar='month',offsetmonth=FALSE,offsetpop=NULL){
  ## checks
  if (refmonth<1|refmonth>12){stop("Reference month must be between 1 and 12")}
  ## original call with defaults (see amer package)
  ans <- as.list(match.call())
  frmls <- formals(deparse(ans[[1]]))
  add <- which(!(names(frmls) %in% names(ans)))
  call<-as.call(c(ans, frmls[add]))

  monthvar=with(data,get(monthvar))
  cmonthvar=class(monthvar)
  ## If month is a character, create the numbers
  if(cmonthvar%in%c('factor','character')){
     if(cmonthvar=='character'){
        if(max(nchar(monthvar))==3){mlevels=substr(month.name,1,3)}else{mlevels=month.name}
        monthvar=factor(monthvar,levels=mlevels)
     }
     months=as.numeric(monthvar)
     data$month=months # add to data for flagleap
     months=as.factor(months)
     levels(months)[months]<-month.abb[months]
     months<-relevel(months.u,ref=month.abb[refmonth]) # set reference month
  }
  ## Transform month numbers to names
  if(cmonthvar%in%c('integer','numeric')){
    months.u<-as.factor(monthvar)  
    nums<-as.numeric(nochars(levels(months.u))) # Month numbers
    levels(months.u)[nums]<-month.abb[nums]
    months<-relevel(months.u,ref=month.abb[refmonth]) # set reference month
  }
  ## prepare data/formula
  parts<-paste(formula)
  f<-as.formula(paste(parts[2],parts[1],parts[3:length(formula)],'+months'))
  dep<-parts[2] # dependent variable
  days<-flagleap(data=data,report=FALSE,matchin=T) # get the number of days in each month
  l<-nrow(data)
  if(is.null(offsetpop)==FALSE){poff=with(data,eval(offsetpop))} else{poff=rep(1,l)} # 
  if(offsetmonth==TRUE){moff=days$ndaysmonth/(365.25/12)} else{moff=rep(1,l)} # days per month divided by average month length
###  data$off<-log(poff*moff)
  off<-log(poff*moff)  # 
  fit<-glm(formula=f,data=data,family=family,offset=off)
  ## return
  toret<-list()
  toret$call<-call
  toret$glm<-fit
  toret$fitted.values<-fitted(fit)
  toret$residuals<-residuals(fit)
  class(toret)<-'monthglm'
  return(toret)
}

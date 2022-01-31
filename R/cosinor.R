# cosinor.R
# cosinor function using a GLM
# available link functions = identity, log, logit, cloglog
# date = date for daily data, month for monthly data
# type =  monthly/weekly/daily/hourly
# phase results based on 1 cycle per year
# Aug 2014



#' Cosinor Regression Model for Detecting Seasonality in Yearly Data or
#' Circadian Patterns in Hourly Data
#' 
#' Fits a cosinor model as part of a generalized linear model.
#' 
#' The cosinor model captures a seasonal pattern using a sinusoid. It is
#' therefore suitable for relatively simple seasonal patterns that are
#' symmetric and stationary. The default is to fit an annual seasonal pattern
#' (\code{cycle}=1), but other higher frequencies are possible (e.g., twice per
#' year: \code{cycle}=2). The model is fitted using a sine and cosine term that
#' together describe the sinusoid. These parameters are added to a generalized
#' linear model, so the model can be fitted to a range of dependent data (e.g.,
#' Normal, Poisson, Binomial). Unlike the \code{nscosinor} model, the cosinor
#' model can be applied to unequally spaced data.
#' 
#' @param formula regression formula.
#' @param date a date variable if type=\dQuote{daily}, or an integer between 1
#' and 53 if type=\dQuote{weekly}, or an integer between 1 and 12 if
#' type=\dQuote{monthly}, or a \link{POSIXct} date if type=\dQuote{hourly}.
#' @param data data set as a data frame.
#' @param family a description of the error distribution and link function to
#' be used in the model. Available link functions: identity, log, logit,
#' cloglog. Note, it must have the parentheses.
#' @param alpha significance level, set to 0.05 (default).
#' @param cycles number of seasonal cycles per year if type=\dQuote{daily},
#' \dQuote{weekly} or \dQuote{monthly}; number of cycles per 24 hours if
#' type=\dQuote{hourly}
#' @param rescheck plot the residual checks (TRUE/FALSE), see
#' \code{\link{seasrescheck}}.
#' @param type \dQuote{daily} for daily data (default), or \dQuote{weekly} for
#' weekly data, or \dQuote{monthly} for monthly data, or \dQuote{hourly} for
#' hourly data.
#' @param offsetmonth include an offset to account for the uneven number of
#' days in the month (TRUE/FALSE). Should be used for monthly counts
#' (type=\dQuote{monthly}) (with \code{family=poisson()}).
#' @param offsetpop include an offset for the population (optional), this
#' should be a variable in the data frame. Do not log-transform this offset, as
#' the transform is applied by the code.
#' @param text add explanatory text to the returned phase value (TRUE) or
#' return a number (FALSE). Passed to the \code{invyrfraction} function.
#' @return Returns an object of class \dQuote{Cosinor} with the following
#' parts: \item{call}{the original call to the cosinor function.} \item{glm}{an
#' object of class \code{glm} (see \code{\link{glm}}).} \item{fitted}{fitted
#' values for intercept and cosinor only (ignoring other independent
#' variables).} \item{fitted.plus}{standard fitted values, including all other
#' independent variables.} \item{residuals}{residuals.} \item{date}{name of the
#' date variable (in Date format when type=\sQuote{daily}).}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{summary.Cosinor}, \code{plot.Cosinor}
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @examples
#' 
#' ## cardiovascular disease data (offset based on number of days in...
#' ## ...the month scaled to an average month length)
#' data(CVD)
#' res = cosinor(cvd~1, date='month', data=CVD, type='monthly',
#'               family=poisson(), offsetmonth=TRUE)
#' summary(res)
#' seasrescheck(res$residuals) # check the residuals
#' ## stillbirth data
#' data(stillbirth)
#' res = cosinor(stillborn~1, date='dob', data=stillbirth,
#'               family=binomial(link='cloglog'))
#' summary(res)
#' plot(res)
#' ## hourly indoor temperature data
#' res = cosinor(bedroom~1, date='datetime', type='hourly', data=indoor)
#' summary(res)
#' # to get the p-values for the sine and cosine estimates
#' summary(res$glm)
#' 
#' @export cosinor
cosinor<-function(formula, date, data,family=gaussian(), alpha=0.05,
                  cycles=1, rescheck=FALSE, type='daily', offsetmonth=FALSE,
                  offsetpop=NULL,text=TRUE){
  ## checks
  classes = lapply(data, class) # classes of all variables
  this.class=as.character(classes[which(names(data)==date)]) # also used later
  if (!is.logical(offsetmonth)){
    stop("Error: 'offsetmonth' must be of type logical")}
  if (type!='daily'&type!='weekly'&type!='monthly'&type!='hourly'){stop("type must be daily, weekly, monthly or hourly")}
  if (type=='hourly'&length(grep('POSIXct',this.class))==0){
    stop("date variable must be of class POSIXct when type='hourly'")}
  if (type=='daily'&this.class!='Date'){
    stop("date variable must be of class Date when type='daily'")}
  if (alpha<=0|alpha>=1){stop("alpha must be between 0 and 1")}
  if (type=='hourly'&offsetmonth==TRUE){
    stop("do not use monthly offset for hourly data")}
  
  ## original call with defaults (see amer package)
  link<-family$link
  ans <- as.list(match.call())
  frmls <- formals(deparse(ans[[1]]))
  add <- which(!(names(frmls) %in% names(ans)))
  call<-as.call(c(ans, frmls[add],link=link))

  ## make the formula
  parts<-paste(formula)
  f<-as.formula(paste(parts[2],parts[1],parts[3:length(formula)],'+cosw+sinw'))

  ## get the year/hour fraction
  to.frac=subset(data,select=date)[,1]
  if(type=='hourly'){
    number = as.numeric(format(to.frac,'%H'))+(as.numeric(format(to.frac,'%M'))/60)+(as.numeric(format(to.frac,'%S'))/60*60)
    frac = number/24
  }
  if(type!='hourly'){
    class(to.frac)=this.class # return to class (needed for date class)
    frac = yrfraction(to.frac,type=type) # 
  }
  data$cosw<-cos(frac*2*pi*cycles)
  data$sinw<-sin(frac*2*pi*cycles)
  newdata<-data.frame(cosw=data$cosw,sinw=data$sinw) # used later
  poff=rep(1,nrow(data))
  if(is.null(offsetpop)==FALSE){poff=offsetpop}
  moff=rep(1,nrow(data))
  if(offsetmonth==TRUE){
    days = flagleap(data=data, report=FALSE, matchin=TRUE) # get the number of days in each month
    moff = days$ndaysmonth/(365.25/12) # days per month divided by average month length
  }
  offset <- log(poff*moff)
  # generalized linear model
  model<-glm(f, data=data, family=family, offset=offset)
  s<-summary(model)
  res<-residuals(model)

  ## create predicted data (intercept + sinusoid)
  cnames<-row.names(s$coefficients)
  cindex<-sum(as.numeric(cnames=='cosw')*(1:length(cnames)))
  sindex<-sum(as.numeric(cnames=='sinw')*(1:length(cnames)))
  fitted=fitted(model) # standard fitted values
  pred<-s$coefficients[1,1]+(s$coefficients[cindex,1]*newdata$cosw)+
    (s$coefficients[sindex,1]*newdata$sinw)
  # back-transform:
  if (s$family$link=='log'){pred<-exp(pred)}
  if (s$family$link=='logit'){pred<-exp(pred)/(1+exp(pred))}
  if (s$family$link=='cloglog'){pred<-1-exp(-exp(pred))}
  # return:
  toret<-list()
  toret$call<-call
  toret$glm<-model # changed to model rather than summary
  toret$fitted.plus<-fitted
  toret$fitted.values<-pred
  toret$residuals<-res
  toret$date<-date
  class(toret)<-'Cosinor'
  return(toret)
}

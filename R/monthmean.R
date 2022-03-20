# monthmean.R
# function to calculate monthly mean or adjusted monthly mean for count data
# Assumes that data contains two variables: month and year
# November 2009



#' Monthly Means
#' 
#' Calculate the monthly mean or adjusted monthly mean for count data.
#' 
#' For time series recorded at monthly intervals it is often useful to examine
#' (and plot) the average in each month. When using count data we should adjust
#' the mean to account for the unequal number of days in the month (e.g., 31 in
#' January and 28 or 29 in February).
#' 
#' This function assumes that the data set (\code{data}) contains variables for
#' the year and month called year and month, respectively.
#' 
#' @param data data set as a data frame.
#' @param resp response variable in the data set for which the means will be
#' calculated.
#' @param offsetpop optional population, used as an offset (default=NULL).
#' @param adjmonth adjust monthly counts and scale to a 30 day month
#' (\sQuote{\code{thirty}}) or the average month length
#' (\sQuote{\code{average}}) (default=FALSE).
#' @return Returns an object of class \dQuote{Monthmean} with the following
#' parts: \item{mean}{a vector of length 12 with the monthly means.}
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{plot.Monthmean}
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @examples
#' \donttest{
#' # cardiovascular disease data
#' data(CVD)
#' mmean = monthmean(data=CVD, resp='cvd', offsetpop=expression(pop/100000), adjmonth='average')
#' mmean
#' plot(mmean)
#' }
#' 
#' @export monthmean
monthmean<-function(data,resp,offsetpop=NULL,adjmonth=FALSE){
# checks
  if (is.null(data)==TRUE){stop("must have an input data set (data)")}
  if (is.null(resp)==TRUE){stop("must have an input variable (resp)")}
  nnn<-names(data)
  if (any(nnn=='year')==FALSE){stop("data set must contain a variable with the 4 digit year called 'year'")}
  if (any(nnn=='month')==FALSE){stop("data set must contain a variable with the numeric month called 'month'")}
# calculations
  days<-flagleap(data) # get the number of days in each month
  mean<-vector(length=12,mode='numeric')
  if (adjmonth=='thirty') adjf=30  
  if (adjmonth=='average') adjf=365.25/12
  if (is.null(offsetpop)==TRUE) adjp=1 else adjp=with(data,eval(offsetpop)) # population adjustment
  xxxx=subset(data,select=resp)[,1] # instead of with
  for (i in 1:12){
     if (adjmonth!=FALSE) mean[i]<-mean(xxxx[data$month==i]*(adjf/days$ndaysmonth[i])/adjp)
     else mean[i]<-mean(xxxx[data$month==i]/adjp) # no monthly adjustment
  }
# return
  toret<-list()
  toret$mean<-as.vector(mean)
  class(toret)<-'Monthmean'
  return(toret)
}

# example
# mmean<-monthmean(data=CVD,resp=cvd,offsetpop=expression(pop/100000))
# adjmean<-monthmean(data=elderly,resp=cvd,adjmonth='average',offsetpop=expression(pop/100000))

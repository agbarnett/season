# seasrescheck.R
# seasonal residual checks
# April 2009



#' Seasonal Residual Checks
#' 
#' Tests the residuals for any remaining seasonality.
#' 
#' Plots: i) histogram of the residuals, ii) a scatter plot against residual
#' order, iii) the autocovariance, iv) the cumulative periodogram (see
#' \code{\link{cpgram}})
#' 
#' @param res residuals from some time series regression model.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#' \donttest{
#' # cardiovascular disease data
#' # (use an offset of the scaled number of days in a month)
#' data(CVD)
#' model = cosinor(cvd~1, date='month', data=CVD, type='monthly',
#'                 family=poisson(), offsetmonth=TRUE)
#' seasrescheck(resid(model))
#' }
#' 
#' @export seasrescheck
seasrescheck<-function(res){
op <- par(no.readonly = TRUE) # the whole list of settable par's.
par(mfrow=c(2,2),lwd=1)
# histogram
par(mai=c(0.7,0.7,0.1,0.1)) # c(bottom, left, top, right)
hist(res,col='gray',main='',xlab='')
# scatter plot
plot(res,type='p',main='',xlab='')
lines(c(1,length(res)),c(0,0),lty=2)
# autocovariance
acf(res,type='correlation',main='',ylab='Autocorrelation')
# cumulative periodogram
cpgram(res,main='')
par(mfrow=c(1,1))
# box plot?
par(op) # restore graphic settings
}

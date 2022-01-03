# summary.Cosinor.R
# Aug 2014 (added hourly)



#' Summary for a Cosinor
#' 
#' The default print method for a \code{Cosinor} object produced by
#' \code{cosinor}.
#' 
#' Summarises the sinusoidal seasonal pattern and tests whether there is
#' statistically significant seasonal or circadian pattern (assuming a smooth
#' sinusoidal pattern). The amplitude describes the average height of the
#' sinusoid, and the phase describes the location of the peak. The scale of the
#' amplitude depends on the link function. For logistic regression the
#' amplitude is given on a probability scale. For Poisson regression the
#' amplitude is given on an absolute scale.
#' 
#' 
#' @param object a \code{Cosinor} object produced by \code{cosinor}.
#' @param digits minimal number of significant digits, see \code{print.default}
#' @param \dots further arguments passed to or from other methods.
#' @return \item{n}{sample size.} \item{amp}{estimated amplitude.}
#' \item{amp.scale}{the scale of the estimated amplitude (empty for standard
#' regression; \sQuote{probability scale} for logistic regession;
#' \sQuote{absolute scale} for Poisson regression).} \item{phase}{estimated
#' peak phase on a time scale.} \item{lphase}{estimated low phase on a time
#' scale (half a year after/before \code{phase}).}
#' \item{significant}{statistically significant sinusoid (TRUE/FALSE).}
#' \item{alpha}{statistical significance level.} \item{digits}{minimal number
#' of significant digits.} \item{text}{add explanatory text to the returned
#' phase value (TRUE) or return a number (FALSE).} \item{type}{type of data
#' (yearly/monthly/weekly/hourly).} \item{ctable}{table of regression
#' coefficients.}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{cosinor}, \code{plot.Cosinor}, \code{invyrfraction}
#' @export
summary.Cosinor = function(object, digits = 2, ...){
 type = object$call$type 
## Checks
 if (class(object)!= "Cosinor"){stop("Object must be of class 'Cosinor'")} 
 s = summary(object$glm) # create summary
 cnames = row.names(s$coefficients)
 cindex = sum(as.numeric(cnames == 'cosw')*(1:length(cnames)))
 sindex = sum(as.numeric(cnames == 'sinw')*(1:length(cnames)))
# amplitude and phase
 amp = sqrt((s$coefficients[cindex,1]^2)+(s$coefficients[sindex,1]^2))
 addition = ''
 link = s$family$link
 if (is.null(s$family$link)){link = ' '}
 if (link == 'logit'){
 p1 = exp(s$coefficients[1,1])/(1+exp(s$coefficients[1,1])) # back-transform amp
 p2 = exp(s$coefficients[1,1]+amp)/(1+exp(s$coefficients[1,1]+amp)) # back-transform amp
 amp = p2-p1
 addition = "(probability scale)"
 }
 if (link == 'cloglog'){
 p1 = 1-exp(-exp(s$coefficients[1,1]))
 p2 = 1-exp(-exp(s$coefficients[1,1]+amp))
 amp = p2-p1
 addition = "(probability scale)"
 }
 if (link == 'log'){
 amp = exp(s$coefficients[1,1]+amp)-exp(s$coefficients[1,1])
 addition = "(absolute scale)"
 }
 phaser = phasecalc(cosine = s$coefficients[cindex,1],sine = s$coefficients[sindex,1]);
# convert radian phase to a date
 phase = invyrfraction(frac = phaser/(2*pi),type = object$call$type,text = object$call$text)
# reverse phase (low)
 lphaser = phaser+pi;
 if (lphaser<0) { lphaser = lphaser+(2*pi)} # first put in 0 to 2pi range
 if (lphaser>(2*pi)) { lphaser = lphaser-(2*pi)}
 lphase = invyrfraction(frac = lphaser/(2*pi),type = object$call$type,text = object$call$text)
# statistical signficance
 toreport = rbind(s$coefficients[cindex,],s$coefficients[sindex,])
 adjusted = eval(object$call$alpha)/2
 significant = as.logical(sum(toreport[,4]<adjusted))
# returns
 ret = list()
 ret$n = length(object$residuals)
 ret$amp = amp
 ret$amp.scale = addition
 ret$phase = phase
 ret$lphase = lphase
 ret$significant = significant
 ret$alpha = object$call$alpha
 ret$digits = digits
 ret$text = object$call$text # display phase as text (TRUE/FALSE)
 ret$type = type
 ret$ctable = s$coefficients # regression table (march 2020)
 class(ret) = "summary.Cosinor"
 ret # uses print.summary.Cosinor
}

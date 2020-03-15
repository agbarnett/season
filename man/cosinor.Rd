\name{cosinor}
\alias{cosinor}
\title{Cosinor Regression Model for Detecting Seasonality in Yearly Data or Circadian Patterns in Hourly Data}
\description{Fits a cosinor model as part of a generalized linear model.}
\usage{cosinor(formula, date, data, family=gaussian() ,alpha=0.05, cycles=1,
               rescheck=FALSE, type='daily', offsetmonth=FALSE, offsetpop=NULL, text=TRUE)}
\arguments{
  \item{formula}{regression formula.}
  \item{date}{a date variable if type=\dQuote{daily}, or an integer
    between 1 and 53 if type=\dQuote{weekly}, or an integer
    between 1 and 12 if type=\dQuote{monthly}, or a \link{POSIXct} date if type=\dQuote{hourly}.}
    \item{data}{data set as a data frame.}
  \item{family}{a description of the error distribution and link
    function to be used in the model. Available link functions:
    identity, log, logit, cloglog. Note, it must have the parentheses.}
  \item{alpha}{significance level, set to 0.05 (default).}
  \item{cycles}{number of seasonal cycles per year if type=\dQuote{daily}, \dQuote{weekly} or \dQuote{monthly}; number of cycles per 24 hours if type=\dQuote{hourly}}
  \item{rescheck}{plot the residual checks (TRUE/FALSE), see
    \code{\link{seasrescheck}}.}
  \item{type}{\dQuote{daily} for daily data (default), or
    \dQuote{weekly} for weekly data, or
    \dQuote{monthly} for monthly data, or
    \dQuote{hourly} for hourly data.}
  \item{offsetmonth}{include an offset to account for the uneven number
    of days in the month (TRUE/FALSE). Should be used for monthly counts (type=\dQuote{monthly})
    (with \code{family=poisson()}).}
  \item{offsetpop}{include an offset for the population (optional), this
    should be a variable in the data frame. Do not log-transform this offset, as the transform is applied by the code.}
  \item{text}{add explanatory text to the returned phase value (TRUE) or
    return a number (FALSE). Passed to the \code{invyrfraction}
    function.}
}
\details{The cosinor model captures a seasonal pattern using a
  sinusoid. It is therefore suitable for relatively simple seasonal
  patterns that are symmetric and stationary. The default is to fit an
  annual seasonal pattern (\code{cycle}=1), but other higher frequencies are
  possible (e.g., twice per year: \code{cycle}=2). The model is fitted
  using a sine and cosine term that together describe the
  sinusoid. These parameters are added to a generalized linear model, so
  the model can be fitted to a range of dependent data (e.g., Normal,
  Poisson, Binomial). Unlike the \code{nscosinor} model, the cosinor
  model can be applied to unequally spaced data.}
\value{
Returns an object of class \dQuote{Cosinor} with the following parts:
  \item{call}{the original call to the cosinor function.}
  \item{glm}{an object of class \code{glm} (see \code{\link{glm}}).}
  \item{fitted}{fitted values for intercept and cosinor only (ignoring
    other independent variables).}
  \item{fitted.plus}{standard fitted values, including all other independent variables.}
  \item{residuals}{residuals.}
  \item{date}{name of the date variable (in Date format when type=\sQuote{daily}).}
}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
    Health Data}. Springer.}
\seealso{\code{summary.Cosinor}, \code{plot.Cosinor}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
## cardiovascular disease data (offset based on number of days in...
## ...the month scaled to an average month length)
data(CVD)
res = cosinor(cvd~1, date='month', data=CVD, type='monthly',
              family=poisson(), offsetmonth=TRUE)
summary(res)
seasrescheck(res$residuals) # check the residuals
## stillbirth data
data(stillbirth)
res = cosinor(stillborn~1, date='dob', data=stillbirth,
              family=binomial(link='cloglog'))
summary(res)
plot(res)
## hourly indoor temperature data
res = cosinor(bedroom~1, date='datetime', type='hourly', data=indoor)
summary(res)
# to get the p-values for the sine and cosine estimates
summary(res$glm)
}

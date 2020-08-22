\name{seasrescheck}
\alias{seasrescheck}
\title{Seasonal Residual Checks}
\description{Tests the residuals for any remaining seasonality.}
\usage{seasrescheck(res)}
\arguments{
  \item{res}{residuals from some time series regression model.}
}
\details{Plots: i) histogram of the residuals, ii) a scatter plot against residual order, iii) the autocovariance, iv) the cumulative periodogram (see \code{\link{cpgram}})}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
# cardiovascular disease data
# (use an offset of the scaled number of days in a month)
data(CVD)
model = cosinor(cvd~1, date='month', data=CVD, type='monthly',
                family=poisson(), offsetmonth=TRUE)
seasrescheck(resid(model))
}
}

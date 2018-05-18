\name{nonlintest}
\alias{nonlintest}
\title{Test of Non-linearity of a Time Series}
\description{A bootstrap test of non-linearity in a time series using the third-order moment.}
\usage{nonlintest(data, n.lag, n.boot, alpha=0.05)}
\arguments{
  \item{data}{a vector of equally spaced numeric observations (time series).}
  \item{n.lag}{the number of lags tested using the third-order moment, maximum = length of time series.}
  \item{n.boot}{the number of bootstrap replications (suggested minimum of 100; 1000 or more would be better).}
  \item{alpha}{statistical significance level of test (default=0.05).}
}
\details{The test uses \code{aaft} to create linear surrogates with the same second-order properties, but no (third-order) non-linearity.
The third-order moments (\code{third}) of these linear surrogates and the actual series are then compared from lags 0 up to \code{n.lag} (excluding the skew at the co-ordinates (0,0)).
The bootstrap test works on the overall area outside the limits, and gives an indication of the overall non-linearity.
The plot using \code{region} shows those co-ordinates of the third order moment that exceed the null hypothesis limits, and can be a useful clue for guessing the type of non-linearity.
For example, a large value at the co-ordinates (0,1) might be caused by a bi-linear series \eqn{X_t=\alpha X_{t-1}\varepsilon_{t-1} +\varepsilon_t}.}
\value{
Returns an object of class \dQuote{nonlintest} with the following parts:
  \item{region}{the region of the third order moment where the test exceeds the limits (up to \code{n.lag}).}
  \item{n.lag}{the maximum lag tested using the third-order moment.}
  \item{stats}{a list of following statistics for the area outside the test limits:}
  \item{outside}{the total area outside of limits (summed over the whole third-order moment).}
  \item{stan}{the total area outside the limits divided by its standard deviation to give a standardised estimate.}
  \item{median}{the median area outside the test limits.}
  \item{upper}{the (1-\code{alpha})th percentile of the area outside the limits.}
  \item{pvalue}{Bootstrap p-value of the area outside the limits to test if the series is linear.}
  \item{test}{Reject the null hypothesis that the series is linear (TRUE/FALSE).}
}
\seealso{\code{print.nonlintest}, \code{plot.nonlintest}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\references{Barnett AG \& Wolff RC (2005) A Time-Domain Test for Some Types of Nonlinearity, \emph{IEEE Transactions on Signal Processing}, vol 53, pages 26--33}
\examples{\donttest{
data(CVD)
\dontrun{test.res = nonlintest(data=CVD$cvd, n.lag=4, n.boot=1000)}
}
}

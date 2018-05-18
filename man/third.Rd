\name{third}
\alias{third}
\title{Third-order Moment}
\description{Estimated third order moment for a time series.}
\usage{third(data, n.lag, centre=TRUE, outmax=TRUE, plot=TRUE)}
\arguments{
  \item{data}{a vector of equally spaced numeric observations (time series).}
  \item{n.lag}{the number of lags, maximum = length of time series.}
  \item{centre}{centre series by subtracting mean (default=TRUE).}
  \item{outmax}{display the (x,y) lag co-ordinates for the maximum and minimum values (default=TRUE).}
  \item{plot}{contour plot of the third order moment (default=TRUE).}
}
\details{The third-order moment is the extension of the second-order moment (essentially the autocovariance).
The equation for the third order moment at lags (j,k) is: \eqn{n^{-1}\sum X_t X_{t+j} X_{t+k}}.
The third-order moment is useful for testing for non-linearity in a time series, and is used by \code{nonlintest}.}
\value{
  \item{waxis}{The axis --\code{n.lag} to \code{n.lag}.}
  \item{third}{The estimated third order moment in the range --n.lag to n.lag, including the symmetries.}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
data(CVD)
third(CVD$cvd, n.lag=12)
}
}

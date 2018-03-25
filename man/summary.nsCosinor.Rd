\name{summary.nsCosinor}
%%\alias{nscosinor}
\alias{summary.nsCosinor}
\alias{print.summary.nsCosinor}
\title{Summary for a Non-stationary cosinor}
\description{The default summary method for a \code{nsCosinor} object produced by \code{nscosinor}.}
\usage{
\method{summary}{nsCosinor}(object, ...)
\method{print}{summary.nsCosinor}(x, ...)
}
\arguments{
  \item{object}{a \code{nsCosinor} object produced by \code{nscosinor}.}
  \item{x}{a \code{summary.nsCosinor} object produced by
    \code{summary.nsCosinor}.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\value{
\item{cycles}{vector of cycles in units of time, e.g., for a six and twelve month pattern \code{cycles=c(6,12)}.}
\item{niters}{total number of MCMC samples.}
\item{burnin}{number of MCMC samples discarded as a burn-in.}
\item{tau}{vector of smoothing parameters, tau[1] for trend, tau[2] for
  1st seasonal parameter, tau[3] for 2nd seasonal parameter, etc.}
\item{stats}{summary statistics (mean and confidence interval) for the
  residual standard deviation, the standard deviation for each seasonal
  cycle, and the amplitude and phase for each cycle.}
}
\details{
  The amplitude describes the average height of each seasonal
  cycle, and the phase describes the location of the peak. The results
  for the phase are given in radians (0 to 2\eqn{\pi}), they can be
  transformed to the time scale using the \code{invyrfraction} making
  sure to first divide by 2\eqn{\pi}.
  
  
The larger the standard deviation for the seasonal cycles, the greater
the non-stationarity. This is because a larger standard deviation means
more change over time.
}
\seealso{\code{nscosinor}, \code{plot.nsCosinor}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}


\name{peri}
\alias{peri}
\title{Periodogram}
\description{Estimated periodogram using the fast Fourier transform (\code{fft}).}
\usage{peri(data,adjmean=TRUE,plot=TRUE)}
\arguments{
  \item{data}{a data frame.}
  \item{adjmean}{subtract the mean from the series before calculating the periodogram (default=TRUE).}
  \item{plot}{plot the estimated periodogram (default=TRUE).}
}
\value{
  \item{peri}{periodogram, I(\eqn{\omega}).}
  \item{f}{frequencies in radians, \eqn{\omega}.}
  \item{c}{frequencies in cycles of time, \eqn{2\pi/\omega}.}
  \item{amp}{amplitude periodogram.}
  \item{phase}{phase periodogram.}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{
data(CVD)
p = peri(CVD$cvd)
}
}


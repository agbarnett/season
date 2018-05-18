\name{aaft}
\alias{aaft}
\title{Amplitude Adjusted Fourier Transform (AAFT)}
\description{Generates random linear surrogate data of a time series with the same second-order properties.}
\usage{aaft(data, nsur)}
\arguments{
  \item{data}{a vector of equally spaced numeric observations (time series).}
  \item{nsur}{the number of surrogates to generate (1 or more).}
}
\details{The AAFT uses phase-scrambling to create a surrogate of the time series that has a similar spectrum (and hence similar second-order statistics).
The AAFT is useful for testing for non-linearity in a time series, and is used by \code{nonlintest}.}
\value{
  \item{surrogates}{a matrix of the \code{nsur} surrogates.}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\references{Kugiumtzis D (2000) Surrogate data test for nonlinearity including monotonic transformations, \emph{Phys. Rev. E}, vol 62}
\examples{
\donttest{
data(CVD)
surr = aaft(CVD$cvd, nsur=1)
plot(CVD$cvd, type='l')
lines(surr[,1], col='red')
}
}


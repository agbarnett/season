\name{sinusoid}
\alias{sinusoid}
\title{Plot a sinusoid}
\description{Plots a sinusoid over 0 to 2\eqn{\pi}.}
\usage{sinusoid(amplitude, frequency, phase, ...)}
\arguments{
  \item{amplitude}{the amplitude of the sinsuoid (its maximum value).}
  \item{frequency}{the frequency of the sinusoid in 0 to 2\eqn{\pi} (number of cycles).}
  \item{phase}{the phase of the sinusoid (location of the peak).}
  \item{\dots}{additional arguments passed to the plot.}
}
\details{Sinusoidal curves are very useful for modelling seasonal data. A sinusoid is plotted using the equation: \eqn{A\cos(ft-P), t=0,\ldots,2 \pi}, where \eqn{A} is the amplitude, \eqn{f} is the frequency, \eqn{t} is time and \eqn{P} is the phase.}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{sinusoid(amplitude=1, frequency=1, phase=1)}
}

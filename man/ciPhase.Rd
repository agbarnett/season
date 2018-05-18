\name{ciPhase}
\alias{ciPhase}
\title{Mean and Confidence Interval for Circular Phase}
\description{Calculates the mean and confidence interval for the phase based on a chain of MCMC samples.}
\usage{ciPhase(theta, alpha = 0.05)}
\arguments{
  \item{theta}{chain of Markov chain Monte Carlo (MCMC) samples of the phase.}
  \item{alpha}{the confidence level (default = 0.05 for a 95\% confidence interval).}
}
\value{
  \item{mean}{the estimated mean phase.}
  \item{lower}{the estimated lower limit of the confidence interval.}
  \item{upper}{the estimated upper limit of the confidence interval.}
}
\details{The estimates of the phase are rotated to have a centre of \eqn{\pi}, the point on the circumference of a unit radius circle that is furthest from zero. The mean and confidence interval are calculated on the rotated values, then the estimates are rotated back.}
\references{Fisher, N. (1993) \emph{Statistical Analysis of Circular Data}. Cambridge University Press. Page 36.

Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
theta = rnorm(n=2000, mean=0, sd=pi/50) # 2000 normal samples, centred on zero
hist(theta, breaks=seq(-pi/8, pi/8, pi/30))
ciPhase(theta)
}
}

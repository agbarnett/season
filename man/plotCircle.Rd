\name{plotCircle}
\alias{plotCircle}
\title{Circular Plot}
\description{Circular plot of a monthly variable.}
\usage{plotCircle(months,dp=1, \dots)
}
\arguments{
  \item{months}{monthly variable to plot, the shades of grey of the 12 segments are proportional to this variable. The first result is assumed to be January, the second February, and so on.}
  \item{dp}{decimal places for statistics, default=1.}
  \item{\dots}{additional arguments to \code{plot}}
}
\details{This circular plot can be useful for estimates of an annual seasonal pattern. Darker shades of grey correspond to larger numbers.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
plotCircle(months=seq(1,12,1),dp=0)
}
}

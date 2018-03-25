\name{plot.nsCosinor}
%%\alias{nscosinor}
\alias{plot.nsCosinor}
\title{Plot the results of a Non-stationary cosinor}
\description{Plots the trend and season(s) from a \code{nsCosinor} object produced by \code{nscosinor}.}
\usage{
\method{plot}{nsCosinor}(x, ...)
}
\arguments{
  \item{x}{a \code{nsCosinor} object produced by \code{nscosinor}.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\value{
  \item{gplot}{A plot of class \code{ggplot}}
}
\details{The code produces the season(s) and trend estimates.}
\seealso{\code{nscosinor}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}


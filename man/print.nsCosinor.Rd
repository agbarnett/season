\name{print.nsCosinor}
%%\alias{nscosinor}
\alias{print.nsCosinor}
\title{Print the Results of a Non-stationary Cosinor}
\description{The default print method for a \code{nsCosinor} object produced by \code{nscosinor}.}
\usage{
\method{print}{nsCosinor}(x, ...)
}
\arguments{
  \item{x}{a \code{nsCosinor} object produced by \code{nscosinor}.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\details{Prints out the model call, number of MCMC samples, sample size and residual summary statistics.}
\seealso{\code{nscosinor}, \code{summary.nsCosinor}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}

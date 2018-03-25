\name{kalfil-internal}
\alias{kalfil}
\title{Forward and backward sweep of the Kalman filter}
\description{Internal function to do a forward and backward sweep of the Kalman filter, used by \code{nscosinor}. For internal use only.}
\usage{kalfil(data, f, vartheta, w, tau, lambda, cmean)}
\arguments{
  \item{data}{a data frame.}
  \item{f}{vector of cycles in units of time.}
  \item{vartheta}{variance for noise.}
  \item{w}{variance of seasonal component.}
  \item{tau}{controls flexibility of trend and season.}
  \item{lambda}{distance between observations.}
  \item{cmean}{used to give a vague prior for the starting values.}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}


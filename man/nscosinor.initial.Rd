% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/season-package.R
\name{nscosinor.initial}
\alias{nscosinor.initial}
\title{Initial Values for Non-stationary Cosinor}
\arguments{
\item{data}{a data frame.}

\item{response}{response variable.}

\item{tau}{vector of smoothing parameters, tau[1] for trend, tau[2] for 1st
seasonal parameter, tau[3] for 2nd seasonal parameter, etc. Larger values of
tau allow more change between observations and hence a greater potential
flexibility in the trend and season.}

\item{lambda}{distance between observations (lambda=1/12 for monthly data,
default).}

\item{n.season}{number of seasons.}
}
\description{
Creates initial values for the non-stationary cosinor decomposition
\code{nscosinor}. For internal use only.
}
\author{
Adrian Barnett \email{a.barnett@qut.edu.au}
}

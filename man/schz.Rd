\name{schz}
\alias{schz}
\docType{data}
\title{Schizophrenia births in Australia, 1930--1971}
\description{
  Monthly number of babies born with schizophrenia in Australia from 1930 to 1971. The national number of births and number of cases are missing for January 1960 are missing.}
\usage{data(schz)}
\format{
  A data frame with 504 observations on the following 6 variables.
  \describe{
    \item{\code{year}}{year of birth}
    \item{\code{month}}{month of birth}
    \item{\code{yrmon}}{a combination of year and month: \eqn{year+(month-1)/12}}
    \item{\code{NBirths}}{monthly number of births in Australia, used as an offset}
    \item{\code{SczBroad}}{monthly number of schizophrenia births using the broad diagnostic criteria}
    \item{\code{SOI}}{southern oscillation index}
  }
}
\source{
  From Prof John McGrath and colleagues, The University of Queensland, Brisbane.
}
\examples{
\donttest{
data(schz)
plot(schz$yrmon, schz$SczBroad, type='o', xlab='Date',
     ylab='Number of schizophrenia births')
}
}
\keyword{datasets}


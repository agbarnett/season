\name{indoor}
\alias{indoor}
\docType{data}
\title{Indoor Temperature Data}
\description{
  The data are indoor temperatures (in degrees C) for a bedroom and living room in a house in Brisbane, Australia for the dates 10 July 2013 to 3 October 2013.
  Temperatures were recorded using data loggers which recorded every hour to the nearest 0.5 degrees.}
\usage{indoor}
\format{
  A \code{data.frame} with the following 3 variables.
  \describe{
    \item{\code{datetime}}{date and time in \code{POSIXlt} format}
    \item{\code{living}}{the living room temperature}
    \item{\code{bedroom}}{the bedroom temperature}
  }
}
\source{
  Adrian G Barnett.
}
\examples{
data(indoor)
res = cosinor(bedroom~1, date='datetime', type='hourly', data=indoor)
summary(res)
}
\keyword{datasets}

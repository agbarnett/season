\name{CVD}
\alias{CVD}
\docType{data}
\title{Cardiovascular Deaths in Los Angeles, 1987--2000}
\description{
  Monthly number of deaths from cardiovascular disease in people
  aged 75 and over in Los Angeles for the years 1987 to 2000.
}
\usage{data(CVD)}

\format{
  A data frame with 168 observations on the following 8 variables.
  \describe{
    \item{\code{year}}{year of death}
    \item{\code{month}}{month of death}
    \item{\code{yrmon}}{a combination of year and month:
      \eqn{year+(month-1)/12}}
    \item{\code{cvd}}{monthly number of CVD deaths}
    \item{\code{tmpd}}{mean monthly temperature (degrees Fahrenheit)}
    \item{\code{pop}}{Los Angeles population aged 75+ in the year 2000 (this value is constant as only one year was available, but in general the population will (of course) change over time)}
    \item{\code{ndaysmonth}}{number of days in each month (used as an offset)}
    \item{\code{adj}}{adjusted number of CVD deaths per month using a
      standardised month length. Monthly number of CVD deaths multiplied by (365.25/12)/ndaysmonth. So the standard month length is 30.4 days.}
  }
}

\source{
  From the NMMAPS study.
}
\references{Samet JM, Dominici F, Zeger SL, Schwartz J, Dockery DW
  (2000). \emph{The National Morbidity, Mortality, and Air
    Pollution Study, Part I: Methods and Methodologic Issues}.
  Research Report 94, Health Effects Institute, Cambridge MA.}
\examples{\donttest{
data(CVD)
plot(CVD$yrmon, CVD$cvd, type='o', xlab='Date',
     ylab='Number of CVD deaths per month')
}
}
\keyword{datasets}

\name{CVDdaily}
\alias{CVDdaily}
\docType{data}
\title{Daily Cardiovascular Deaths in Los Angeles, 1987--2000}
\description{
  Daily number of deaths from cardiovascular disease in people aged 75 and over in Los Angeles for the years 1987 to 2000.
}
\usage{data(CVDdaily)}
\format{
  A data frame with 5114 observations on the following 16 variables.
  \describe{
    \item{\code{date}}{date of death in date format (year-month-day)}
    \item{\code{cvd}}{daily number of CVD deaths}
    \item{\code{dow}}{day of the week (character)}
    \item{\code{tmpd}}{daily mean temperature (degrees Fahrenheit)}
    \item{\code{o3mean}}{daily mean ozone (parts per billion)}
    \item{\code{o3tmean}}{daily trimmed mean ozone (parts per billion)}
    \item{\code{Mon}}{indicator variable for Monday}
    \item{\code{Tue}}{indicator variable for Tuesday}
    \item{\code{Wed}}{indicator variable for Wednesday}
    \item{\code{Thu}}{indicator variable for Thursday}
    \item{\code{Fri}}{indicator variable for Friday}
    \item{\code{Sat}}{indicator variable for Saturday}
    \item{\code{month}}{month (integer from 1 to 12)}
    \item{\code{winter}}{indicator variable for winter}
    \item{\code{spring}}{indicator variable for spring}
    \item{\code{summer}}{indicator variable for summer}
    \item{\code{autumn}}{indicator variable for autumn}
  }
}
\source{
  From the NMMAPS study.
}
\references{Samet JM, Dominici F, Zeger SL, Schwartz J, Dockery DW (2000). \emph{The National Morbidity, Mortality, and Air Pollution Study, Part I: Methods and Methodologic Issues}. Research Report 94, Health Effects Institute, Cambridge MA.}
\examples{\donttest{
data(CVDdaily)
plot(CVDdaily$date, CVDdaily$cvd, type='p', xlab='Date',
     ylab='Number of CVD deaths')
}
}
\keyword{datasets}

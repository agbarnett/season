\name{AFL}
\alias{AFL}
\docType{data}
\title{Australian Football League (AFL) players' birthdays for the 2009 season}
\description{
  The data are: a) the monthly frequencies of birthdays and an expected number based on monthly birth statistics for 1975 to 1991. b) all 617 players' initials and birthdays (excluding non-Australian born players).}
\usage{data(AFL)}
\format{
  A list with the following 5 variables.
  \describe{
    \item{\code{month}}{integer month (1 to 12)}
    \item{\code{players}}{number of players born in each month (12 observations)}
    \item{\code{expected}}{expected number of players born in each month (12 observations)}
    \item{\code{initials}}{player initials (617 observations)}
    \item{\code{dob}}{date of birth in date format (617 observations; year-month-day format)}
  }
}
\source{
  Dates of birth from Wikipedia (\url{http://en.wikipedia.org/wiki/Australian_Football_League}).
}
\examples{
\donttest{
data(AFL)
barplot(AFL$players, names.arg=month.abb)
}
}
\keyword{datasets}

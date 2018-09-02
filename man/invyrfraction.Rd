\name{invyrfraction}
\alias{invyrfraction}
\title{Inverse Fraction of the Year}
\description{Inverts a fraction of the year to a date variable or month fraction.}
\usage{invyrfraction(frac, type="daily", text=TRUE)}
\arguments{
  \item{frac}{a vector of fractions of the year, all between 0 and 1.}
  \item{type}{\dQuote{\code{daily}} for dates, or \dQuote{\code{monthly}} for months.}
  \item{text}{add an explanatory text to the returned value (TRUE) or return a number (FALSE).}
}
\details{Returns the day and month (for \code{daily}) or fraction of the month (for \code{monthly}) given a fraction of the year. Assumes a year length of 365.25 days for \code{daily}. When using \code{monthly} the 1st of January is 1, the 1st of December is 12, and the 31st of December is 12.9.}
\value{
  \item{daym}{date (day and month for \code{daily}) or fractional month (for \code{monthly}).}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
invyrfraction(c(0,0.5,0.99), type='daily')
invyrfraction(c(0,0.5,0.99), type='monthly')
}

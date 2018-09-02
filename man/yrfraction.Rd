\name{yrfraction}
\alias{yrfraction}
\title{Fraction of the Year}
\description{Calculate the fraction of the year for a date variable (after accounting for leap years) or for month.}
\usage{yrfraction(date, type='daily')}
\arguments{
  \item{date}{a date variable if type=\sQuote{\code{daily}}, or an
  integer between 1 and 12 if type=\sQuote{\code{monthly}}.}
  \item{type}{\sQuote{daily} for dates, or \sQuote{\code{monthly}} for months.}
}
\details{Returns the fraction of the year in the range [0,1).}
\value{
  \item{yrfrac}{Fraction of the year.}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
# create fractions for the start, middle and end of the year
date = as.Date(c(0, 181, 364), origin='1991-01-01')
# create fractions based on these dates
yrfraction(date)
yrfraction(1:12, type='monthly')
}

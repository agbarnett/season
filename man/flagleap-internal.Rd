\name{flagleap}
\alias{flagleap}
\title{Count the Number of Days in the Month}
\description{Counts the number of days per month given a range of dates. Used to adjust monthly count data for the at-risk time period. For internal use only.}
\usage{flagleap(data, report=TRUE, matchin=FALSE)}
\arguments{
  \item{data}{data.}
  \item{report}{produce a brief report on the range of time used (default=TRUE).}
  \item{matchin}{expand the result to match the start and end dates, otherwise only dates in the data will be returned (default=FALSE).}
}
\details{The data should contain the numeric variable called
\sQuote{year} as a 4 digit year (e.g., 1973).}
\value{
  \item{year}{year (4 digits).}
  \item{month}{month (2 digits).}
  \item{ndaysmonth}{number of days in the month (either 28, 29, 30 or 31).}
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}

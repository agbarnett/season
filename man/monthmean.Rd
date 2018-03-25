\name{monthmean}
\alias{monthmean}
\title{Monthly means}
\description{Calculate the monthly mean or adjusted monthly mean for count data.}
\usage{monthmean(data, resp, offsetpop=NULL, adjmonth=FALSE)}
\arguments{
  \item{data}{data set as a data frame.}
  \item{resp}{response variable in the data set for which the means will be calculated.}
  \item{offsetpop}{optional population, used as an offset (default=NULL).}
  \item{adjmonth}{adjust monthly counts and scale to a 30 day month (\sQuote{\code{thirty}}) or the average month length (\sQuote{\code{average}}) (default=FALSE).}
}
\details{For time series recorded at monthly intervals it is often useful to examine (and plot) the average in each month. When using count data we should adjust the mean to account for the unequal number of days in the month (e.g., 31 in January and 28 or 29 in February).

This function assumes that the data set (\code{data}) contains variables for the year and month called year and month, respectively.}
\value{
Returns an object of class \dQuote{Monthmean} with the following parts:
  \item{mean}{a vector of length 12 with the monthly means.}
}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
    Health Data}. Springer.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\seealso{\code{plot.Monthmean}}
\examples{
\donttest{
# cardiovascular disease data
data(CVD)
mmean = monthmean(data=CVD, resp='cvd', offsetpop=expression(pop/100000), adjmonth='average')
mmean
plot(mmean)
}
}

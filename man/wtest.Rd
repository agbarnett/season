\name{wtest}
\alias{wtest}
\title{Walter and Elwood's Test of Seasonality}
\description{Tests for a seasonal pattern in Binomial data.}
\usage{wtest(cases, offset, data, alpha=0.05)}
\arguments{
  \item{cases}{variable name for cases (\dQuote{successes}).}
  \item{offset}{variable name for at-risk population (\dQuote{trials}).}
  \item{data}{data frame (optional).}
  \item{alpha}{significance level (default=0.05).}
}
\details{A test of whether monthly data has a sinusoidal seasonal
  pattern. The test has low power compared with the
  \code{\link{cosinor}} test.
}
\value{
\item{test}{test statistic.}
\item{pvalue}{p-value.}
}
\references{Walter, S.D., Elwood, J.M. (1975) A test for seasonality of events with a variable population at risk.
\emph{British Journal of Preventive and Social Medicine} 29, 18--21.

Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health
  Data}. Springer.
}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
data(stillbirth)
# tabulate the total number of births and the number of stillbirths
freqs = table(stillbirth$month,stillbirth$stillborn)
data = list()
data$trials = as.numeric(freqs[,1]+freqs[,2])
data$success = as.numeric(freqs[,2])
# test for a seasonal pattern in stillbirth
test = wtest(cases=success, offset=trials, data=data)
}
}

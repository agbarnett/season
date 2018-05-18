\name{plotMonth}
\alias{plotMonth}
\title{Plot Results by Month}
\description{Plots results by month.}
\usage{
plotMonth(data, resp, panels=12, \dots)
}
\arguments{
  \item{data}{a data frame.}
  \item{resp}{response variable to plot.}
  \item{panels}{number of panels to use in plot (1 or 12). 12 gives one panel per month, 1 plots all the months in the same panel.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\details{Assumes the data frame contains variables called year and month.}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
data(CVD)
plotMonth(data=CVD, resp='cvd', panels=12)
}
}

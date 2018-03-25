\name{plot.monthglm}
%%\alias{monthglm}
\alias{plot.monthglm}
\title{Plot of monthly estimates}
\description{Plots the estimated from a generalized linear model with a categorical variable of month.}
\usage{
\method{plot}{monthglm}(x, alpha=0.05, ylim=NULL, ...)
}
\arguments{
  \item{x}{a \code{monthglm} object produced by \code{monthglm}.}
  \item{alpha}{statistical significance level of confidence intervals.}
  \item{ylim}{y coordinates ranges (the default is NULL, and the limits are automatically calculated).}
  \item{\dots}{additional arguments passed to the plot.}
}
\seealso{\code{monthglm}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{
data(CVD)
mmodel = monthglm(formula=cvd~1, data=CVD, family=poisson(),
                  offsetpop=pop/100000, offsetmonth=TRUE, refmonth=6)
plot(mmodel)
}
}

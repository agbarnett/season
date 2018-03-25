\name{summary.monthglm}
%%\alias{monthglm}
\alias{summary.monthglm}
\alias{print.summary.monthglm}
\title{Summary for a monthglm}
\description{The default summary method for a \code{monthglm} object produced by \code{monthglm}.}
\usage{
\method{summary}{monthglm}(object, ...)
\method{print}{summary.monthglm}(x, ...)
}
\arguments{
  \item{object}{a \code{monthglm} object produced by \code{nscosinor}.}
  \item{x}{a \code{summary.monthglm} object produced by
    \code{summary.monthglm}.}
  \item{\dots}{further arguments passed to or from other methods.}
}
\value{
  \item{n}{sample size.}
  \item{month.ests}{parameter estimates for the intercept and months.}
  \item{month.effect}{scale of the monthly effects. \sQuote{RR} for
    \sQuote{rate ratios}, \sQuote{OR} for \sQuote{odds ratios}, or empty
    otherwise.}
  \item{x}{Object of class \code{monthglm}}
  \item{object}{Object of class \code{monthglm}}
  \item{\dots}{further arguments passed to or from other methods.}
}
\seealso{\code{monthglm}, \code{plot.monthglm}}
\details{The estimates are the mean, 95\% confidence interval, Z-value
  and associated p-value (comparing each month to the reference
  month). If Poisson regression was used then the estimates are shown as
  rate ratios. If logistic regression was used then the estimates are
  shown as oddsratios.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}


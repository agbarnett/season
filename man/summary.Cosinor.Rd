\name{summary.Cosinor}
\alias{summary.Cosinor}
\alias{print.summary.Cosinor}
\title{Summary for a cosinor}
\description{The default print method for a \code{Cosinor} object produced by \code{cosinor}.}
\usage{
\method{summary}{Cosinor}(object, digits=2, ...)
\method{print}{summary.Cosinor}(x, ...)
}
\arguments{
  \item{object}{a \code{Cosinor} object produced by \code{cosinor}.}
  \item{x}{a \code{summary.Cosinor} object produced by
    \code{summary.Cosinor}.}
  \item{digits}{minimal number of significant digits, see \code{print.default}}
  \item{\dots}{further arguments passed to or from other methods.}
}
\value{
  \item{n}{sample size.}
  \item{amp}{estimated amplitude.}
  \item{amp.scale}{the scale of the estimated amplitude (empty for standard regression; \sQuote{probability scale} for logistic regession; \sQuote{absolute scale} for Poisson regression).}
  \item{phase}{estimated peak phase on a time scale.}
  \item{lphase}{estimated low phase on a time scale (half a year after/before \code{phase}).}
  \item{significant}{statistically significant sinusoid (TRUE/FALSE).}
  \item{alpha}{statistically significance level.}
  \item{digits}{minimal number of significant digits.}
  \item{text}{add explanatory text to the returned phase value (TRUE) or return a number (FALSE).}
  \item{type}{type of data (yearly/monthly/weekly/hourly).}
}
\details{Summarises the sinusoidal seasonal pattern and tests whether there is statistically significant seasonal or circadian pattern (assuming a smooth sinusoidal pattern). The amplitude describes the average height of the sinusoid, and the phase describes the location of the peak. The scale of the amplitude depends on the link function. For logistic regression the amplitude is given on a probability scale. For Poisson regression the amplitude is given on an absolute scale.}
\seealso{\code{cosinor}, \code{plot.Cosinor}, \code{invyrfraction}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}


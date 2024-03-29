% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.Cosinor.R
\name{summary.Cosinor}
\alias{summary.Cosinor}
\title{Summary for a Cosinor}
\usage{
\method{summary}{Cosinor}(object, digits = 2, ...)
}
\arguments{
\item{object}{a \code{Cosinor} object produced by \code{cosinor}.}

\item{digits}{minimal number of significant digits, see \code{print.default}}

\item{\dots}{further arguments passed to or from other methods.}
}
\value{
\item{n}{sample size.} \item{amp}{estimated amplitude.}
\item{amp.scale}{the scale of the estimated amplitude (empty for standard
regression; \sQuote{probability scale} for logistic regession;
\sQuote{absolute scale} for Poisson regression).} \item{phase}{estimated
peak phase on a time scale.} \item{lphase}{estimated low phase on a time
scale (half a year after/before \code{phase}).}
\item{significant}{statistically significant sinusoid (TRUE/FALSE).}
\item{alpha}{statistical significance level.} \item{digits}{minimal number
of significant digits.} \item{text}{add explanatory text to the returned
phase value (TRUE) or return a number (FALSE).} \item{type}{type of data
(yearly/monthly/weekly/hourly).} \item{ctable}{table of regression
coefficients.}
}
\description{
The default print method for a \code{Cosinor} object produced by
\code{cosinor}.
}
\details{
Summarises the sinusoidal seasonal pattern and tests whether there is
statistically significant seasonal or circadian pattern (assuming a smooth
sinusoidal pattern). The amplitude describes the average height of the
sinusoid, and the phase describes the location of the peak. The scale of the
amplitude depends on the link function. For logistic regression the
amplitude is given on a probability scale. For Poisson regression the
amplitude is given on an absolute scale.
}
\seealso{
\code{cosinor}, \code{plot.Cosinor}, \code{invyrfraction}
}
\author{
Adrian Barnett \email{a.barnett@qut.edu.au}
}

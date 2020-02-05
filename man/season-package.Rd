\name{season-package}
\alias{season-package}
\alias{season}
\docType{package}
\title{Tools for Uncovering and Estimating Seasonal Patterns.
}
\description{
  The package contains graphical methods for displaying seasonal data
  and regression models for detecting and estimating seasonal patterns.

  The regression models can be applied to normal, Poisson or binomial
  dependent data distributions. Tools are available for both time series
  data (equally spaced in time) and survey data (unequally spaced in
time).

  Sinusoidal (parametric) seasonal patterns are available
  (\code{\link{cosinor}}, \code{\link{nscosinor}}), as well as models
  for monthly data (\code{\link{monthglm}}), and the case-crossover
  method to control for seasonality (\code{\link{casecross}}).
}
\details{
  \code{season} aims to fill an important gap in the \R software by
  providing a range of tools for analysing seasonal data. The examples
  are based on health data, but the functions are equally applicable to
  any data with a seasonal pattern.

}
\author{Adrian Barnett <a.barnett<at>qut.edu.au>\cr
  Peter Baker <p.baker1<at>uq.edu.au>

  Maintainer: Adrian Barnett <a.barnett<at>qut.edu.au>
}
\references{Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\keyword{package}
\keyword{ts}
\keyword{models}

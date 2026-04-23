## usethis namespace: start
## usethis namespace: end

## mockable bindings: start
## mockable bindings: end
NULL

#' season: Tools for Uncovering and Estimating Seasonal Patterns.
#'
#' The package contains graphical methods for displaying seasonal data and
#' regression models for detecting and estimating seasonal patterns.
#'
#' The regression models can be applied to normal, Poisson or binomial
#' dependent data distributions. Tools are available for both time series data
#' (equally spaced in time) and survey data (unequally spaced in time).
#'
#' Sinusoidal (parametric) seasonal patterns are available
#' ([cosinor()], [nscosinor()]), as well as models for
#' monthly data ([monthglm()]), and the case-crossover method to
#' control for seasonality ([casecross()]).
#'
#' `season` aims to fill an important gap in the software by providing a
#' range of tools for analysing seasonal data. The examples are based on health
#' data, but the functions are equally applicable to any data with a seasonal
#' pattern.
#'
#' @name season-package
#' @aliases season-package season
#' @docType package
#' @importFrom grDevices gray
#' @importFrom graphics axis box hist lines par plot points polygon rug text
#' @importFrom stats acf as.formula cpgram fft fitted gaussian glm median model.frame na.omit pchisq qchisq qnorm quantile relevel resid residuals rgamma rnorm runif sd time acf as.formula cpgram fft fitted gaussian glm median model.frame na.omit pchisq qchisq qnorm quantile relevel resid residuals rgamma rnorm runif sd time
#' @author Adrian Barnett <a.barnett@qut.edu.au>\cr Peter Baker\cr Oliver Hughes
#'
#' Maintainer: Adrian Barnett <a.barnett@qut.edu.au>
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer.
#' @keywords internal package ts models
"_PACKAGE"

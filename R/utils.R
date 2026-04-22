#' Keep Month Numbers
#'
#' This is an internal function that only keeps the numbers of a string.
#'   This is used in the process of transferring months names to numbers.
#'
#' @param x character text
#'
#' @returns character text with only numbers.
#' @note internal
#' @noRd
keep_month_numbers <- function(x) {
  as.numeric(gsub(pattern = "[^0-9]", replacement = "", x = x))
}

#' Initial Values for Non-stationary Cosinor
#' 
#' Creates initial values for the non-stationary cosinor decomposition
#' `nscosinor`. For internal use only.
#' 
#' 
#' @name nscosinor.initial
#' @param data a data frame.
#' @param response response variable.
#' @param tau vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for 1st
#' seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc. Larger values of
#' tau allow more change between observations and hence a greater potential
#' flexibility in the trend and season.
#' @param lambda distance between observations (lambda=1/12 for monthly data,
#' default).
#' @param n.season number of seasons.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
NULL





#' Random Inverse Gamma Distribution
#' 
#' Internal function to simulate a value from an inverse Gamma distribution,
#' used by `nscosinor`. See the MCMCpack library. For internal use only.
#' 
#' 
#' @name rinvgamma
#' @param n number of observations.
#' @param shape Gamma shape parameter.
#' @param scale Gamma scale parameter (default=1).
NULL


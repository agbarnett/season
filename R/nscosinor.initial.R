# Estimate starting values for seasonal variance based on a linear trend and
# given values for tau
# Dec 2011

#' Initial Values for Non-stationary Cosinor
#'
#' Creates initial values for the non-stationary cosinor decomposition
#' [nscosinor()]. For internal use only.
#'
#' @param data a data frame.
#' @param response response variable.
#' @param tau vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for
#'   1st seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc. Larger
#'   values of tau allow more change between observations and hence a greater
#'   potential flexibility in the trend and season.
#' @param lambda distance between observations (lambda=1/12 for monthly data,
#' default).
#' @param n.season number of seasons.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @note internal
#' @noRd
nscosinor.initial <- function(data, response, tau, lambda = 1 / 12, n.season) {
  k <- 1 # Assume just one season
  kk <- 2 * (k + 1)
  n <- nrow(data)
  Fvec <- rep(c(1, 0), k + 1)
  alpha_j <- matrix(0, kk, n + 1)
  G <- matrix(0, kk, kk)
  G[1, 1] <- 1
  G[1, 2] <- lambda
  G[2, 2] <- 1
  # linear model
  time <- 1:n
  vector.response <- subset(data, select = response)[, 1] # replaced attach
  model <- stats::glm(vector.response ~ time)
  ## put predictions into alpha
  # 1. trend
  alpha_j[1, 2:(n + 1)] <- stats::fitted(model)
  # 2. season
  sdr <- stats::sd(stats::resid(model))
  # sinusoid with amplitude equal to 10% of standard deviation of residuals
  alpha_j[3, 2:(n + 1)] <- (sdr / 10) * cos(2 * pi * (1:n + 1) / 12)
  # estimate initial value for w
  # squared error
  se <- matrix(0, n)
  alphase <- matrix(0, n - 1, k)
  for (t in 2:(n + 1)) {
    #<- time = 1 to n;
    se[t - 1] <- (vector.response[t - 1] - (t(Fvec) %*% alpha_j[, t]))^2
    if (t > 2) {
      # <- 2 to n;
      past <- G %*% alpha_j[, t - 1]
      for (index in 1:k) {
        alphase[t - 2, 1] <- (alpha_j[(2 * 1) + 1, t] - past[(2 * 1) + 1])^2
      }
    }
  }
  # variance initial value
  shape <- (n / 2) - 1
  scale <- sum(se) / 2
  vartheta <- scale / (shape - 1) # based on mean

  # seasonal initial values
  shape <- ((n - 1) / 2) - 1
  scale <- sum(alphase) / 2
  w <- (scale / (shape - 1)) / (tau[2]^2) # use mean rather than random sampling
  initial.value <- c(vartheta, rep(w, n.season))
  return(initial.value)
}

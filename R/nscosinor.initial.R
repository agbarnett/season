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
  f_vec <- rep(c(1, 0), k + 1)
  alpha_j <- matrix(0, kk, n + 1)
  g_mat <- matrix(0, kk, kk)
  g_mat[1, 1] <- 1
  g_mat[1, 2] <- lambda
  g_mat[2, 2] <- 1
  # linear model
  time <- 1:n
  response_vec <- subset(data, select = response)[, 1]
  model <- stats::glm(response_vec ~ time)
  ## put predictions into alpha
  # 1. trend
  alpha_j[1, 2:(n + 1)] <- stats::fitted(model)
  # 2. season
  sd_resid <- stats::sd(stats::resid(model))
  # sinusoid with amplitude equal to 10% of standard deviation of residuals
  alpha_j[3, 2:(n + 1)] <- (sd_resid / 10) * cos(2 * pi * (1:n + 1) / 12)
  # estimate initial value for w
  # squared error
  se <- matrix(0, n)
  alpha_se <- matrix(0, n - 1, k)
  for (t in 2:(n + 1)) {
    #<- time = 1 to n;
    se[t - 1] <- (response_vec[t - 1] - (t(f_vec) %*% alpha_j[, t]))^2
    if (t > 2) {
      # <- 2 to n;
      past <- g_mat %*% alpha_j[, t - 1]
      for (index in 1:k) {
        alpha_se[t - 2, 1] <- (alpha_j[(2 * 1) + 1, t] - past[(2 * 1) + 1])^2
      }
    }
  }
  # variance initial value
  shape <- (n / 2) - 1
  scale <- sum(se) / 2
  var_theta <- scale / (shape - 1) # based on mean

  # seasonal initial values
  shape <- ((n - 1) / 2) - 1
  scale <- sum(alpha_se) / 2
  w <- (scale / (shape - 1)) / (tau[2]^2) # use mean rather than random sampling
  initial_value <- c(var_theta, rep(w, n.season))
  initial_value
}

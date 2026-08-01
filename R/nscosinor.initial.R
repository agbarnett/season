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
  g_mat <- matrix(0, kk, kk)
  g_mat[1, 1] <- 1
  g_mat[1, 2] <- lambda
  g_mat[2, 2] <- 1
  # linear model
  time <- 1:n
  response_vec <- data[[response]]
  model <- stats::glm(response_vec ~ time)
  alpha_j <- calc_alpha_j(model, n)
  # estimate initial value for w
  # squared error
  errors <- compute_squared_errors(
    data_vec = c(0, response_vec),
    alpha_j = alpha_j,
    f_vec = f_vec,
    g_mat = g_mat,
    k = k,
    n = n
  )
  se <- errors$se
  alpha_se <- errors$alpha_se
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

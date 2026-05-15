## stats = estimated amplitude, phases and noise
##

#' Non-stationary Cosinor
#'
#' Decompose a time series using a non-stationary cosinor for the seasonal
#' pattern.
#'
#' This model is designed to decompose an equally spaced time series into a
#' trend, season(s) and noise. A seasonal estimate is estimated as
#' \eqn{s_t=A_t\cos(\omega_t-P_t)}, where *t* is time, \eqn{A_t} is the
#' non-stationary amplitude, \eqn{P_t} is the non-stationary phase and
#' \eqn{\omega_t} is the frequency.
#'
#' A non-stationary seasonal pattern is one that changes over time, hence this
#' model gives potentially very flexible seasonal estimates.
#'
#' The frequency of the seasonal estimate(s) are controlled by `cycle`.
#' The cycles should be specified in units of time. If the data is monthly,
#' then setting `lambda=1/12` and `cycles=12` will fit an annual
#' seasonal pattern. If the data is daily, then setting `lambda=`
#' `1/365.25` and `cycles=365.25` will fit an annual seasonal
#' pattern. Specifying `cycles=` `c(182.6,365.25)` will fit two
#' seasonal patterns, one with a twice-annual cycle, and one with an annual
#' cycle.
#'
#' The estimates are made using a forward and backward sweep of the Kalman
#' filter. Repeated estimates are made using Markov chain Monte Carlo (MCMC).
#' For this reason the model can take a long time to run. To give stable
#' estimates a reasonably long sample should be used (`niters`), and the
#' possibly poor initial estimates should be discarded (`burnin`).
#'
#' @param data Data frame. Assumes year and month exist in data, and no
#'   missing data
#' @param response response variable.
#' @param cycles vector of cycles in units of time, e.g., for a six and twelve
#' month pattern `cycles=c(6,12)`.
#' @param niters total number of MCMC samples (default=1000).
#' @param burnin number of MCMC samples discarded as a burn-in (default=500).
#' @param tau vector of smoothing parameters, `tau[1]` for trend, `tau[2]` for
#'   1st seasonal parameter, `tau[3]` for 2nd seasonal parameter, etc. Larger
#'   values of tau allow more change between observations and hence a greater
#'   potential flexibility in the trend and season.
#' @param lambda distance between observations (lambda=1/12 for monthly data,
#' default).
#' @param div divisor at which MCMC sample progress is reported (default=50).
#' @param monthly TRUE for monthly data.
#' @param alpha Statistical significance level used by the confidence
#' intervals.
#' @returns Returns an object of class "nsCosinor" with the following
#' parts:
#'   * call: the original call to the nscosinor function.
#'   * time: the year and month for monthly data.
#'   * trend: mean trend and 95\% confidence interval.
#'   * season: mean season(s) and 95\% confidence interval(s).
#'   * oseason: overall season(s) and 95\% confidence interval(s). This will
#'     be the same as `season` if there is only one seasonal cycle.
#'   * fitted: fitted values and 95\% confidence interval, based on trend +
#'     season(s).
#'   * residuals: residuals based on mean trend and season(s).
#'   * n: the length of the series.
#'   * chains: MCMC chains (of class mcmc) of variance estimates: standard
#'     error for overall noise (std.error), standard error for season(s)
#'     (std.season), phase(s) and amplitude(s).
#'   * cycles: vector of cycles in units of time.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [plot.nsCosinor()] [summary.nsCosinor()]
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#'
#' Barnett, A.G., Dobson, A.J. (2004) Estimating trends and seasonality in
#' coronary heart disease *Statistics in Medicine*. 23(22) 3505--23.
#' @examples
#' \donttest{
#' # model to fit an annual pattern to the monthly cardiovascular disease data
#' f <- c(12)
#' tau <- c(10,50)
#' \dontrun{
#'   res12 <- nscosinor(
#'     data = CVD,
#'     response = 'adj',
#'     cycles = f,
#'     niters = 5000,
#'     burnin = 1000,
#'     tau = tau
#'     )
#' summary(res12)
#' plot(res12)
#' }
#' }
#'
#' @export
nscosinor <- function(
  data,
  response,
  cycles,
  niters = 1000,
  burnin = 500,
  tau,
  lambda = 1 / 12,
  div = 50,
  monthly = TRUE,
  alpha = 0.05
) {
  names <- names(data)
  year_yes <- sum(names == 'year')
  month_yes <- sum(names == 'month')
  if (year_yes < 1 || month_yes < 1) {
    stop("Data needs to contain numeric year and month variables")
  }
  if (length(tau) != length(cycles) + 1) {
    stop(
      "Need to give a smoothing parameter (tau) for each cycle, ",
      "plus one for the trend"
    )
  }
  resp <- subset(data, select = response)[, 1]
  if (anyNA(resp)) {
    stop("Missing data in the dependent variable not allowed")
  }
  if (any(sum(cycles <= 0))) {
    stop("Cycles cannot be <=0")
  }
  if (burnin > niters) {
    stop("Number of iterations must be greater than burn-in")
  }
  year_month <- data$year + ((data$month - 1) / 12) #
  n <- length(resp)
  k <- length(cycles)
  kk <- 2 * (k + 1)
  ## Get initial values
  good_inits <- nscosinor.initial(
    data = data,
    response = response,
    lambda = lambda,
    tau = tau,
    n.season = k
  )
  var_theta <- sqrt(good_inits[1]) # Initial estimates of var theta
  w <- vector(length = k, mode = "numeric")
  for (index in 1:k) {
    w[index] <- good_inits[2] # Initial estimate of lambda (w)
  }
  ## Empty chain matrices and assign initial values
  chain_amp <- matrix(0, niters + 1, k)
  chain_phase <- matrix(0, niters + 1, k)
  chain_alpha <- array(0, c(kk, n + 1, niters))
  chain_var_theta <- matrix(0, niters + 1)
  chain_lower <- matrix(0, niters + 1, k)
  chain_lower[1, ] <- w
  chain_var_theta[1] <- var_theta
  chain_mean <- rep(10, kk) # starting value for C_j
  for (iter in 1:niters) {
    result <- kalfil(
      resp,
      f = cycles,
      vartheta = chain_var_theta[iter], # changed response to resp
      w = chain_lower[iter, ],
      tau = tau,
      lambda = lambda,
      cmean = chain_mean
    )
    chain_var_theta[iter + 1] <- result$vartheta
    chain_lower[iter + 1, ] <- result$w
    chain_alpha[,, iter] <- result$alpha
    chain_amp[iter + 1, ] <- result$amp
    chain_phase[iter + 1, ] <- result$phase
    chain_mean <- result$cmean
    ## Output iteration progress
    if (iter %% div == 0) {
      cat("Iteration number", iter, "of", niters, "\r", sep = " ")
    }
  }
  ## Get mean & percentiles of alpha (trend & season), & overall fitted values
  trend <- as.data.frame(matrix(0, n, 3))
  season <- as.data.frame(matrix(0, n, 3 * k))
  oseason <- as.data.frame(matrix(0, n, 3))
  new_fitted <- as.data.frame(matrix(0, n, 3))
  names(trend) <- c('mean', 'lower', 'upper')
  names(oseason) <- c('mean', 'lower', 'upper')
  names(new_fitted) <- c('mean', 'lower', 'upper')
  all_seasons <- matrix(data = NA, ncol = niters - burnin, nrow = n)
  snums <- ((1:k) * 2) + 1
  for (i in 1:n) {
    for (j in (burnin + 1):niters) {
      all_seasons[i, j - burnin] <- sum(chain_alpha[snums, i, j])
    }
  }
  prob_lower <- alpha / 2
  prob_upper <- 1 - (alpha / 2)
  num_lower <- round((niters - burnin) * prob_lower)
  num_upper <- round((niters - burnin) * prob_upper)
  for_fitted <- all_seasons + chain_alpha[1, 1:n, (burnin + 1):niters]
  for (i in 1:n) {
    trend$mean[i] <- mean(chain_alpha[1, i, burnin:niters])
    trend$lower[i] <- sum(
      as.numeric(rank(chain_alpha[1, i, burnin:niters]) == num_lower) *
        chain_alpha[1, i, burnin:niters]
    )
    trend$upper[i] <- sum(
      as.numeric(rank(chain_alpha[1, i, burnin:niters]) == num_upper) *
        chain_alpha[1, i, burnin:niters]
    )
    for (j in 2:(k + 1)) {
      snum <- ((j - 1) * 2) + 1
      season[i, ((j - 1) * 3) - 2] <- mean(chain_alpha[snum, i, burnin:niters])
      season[i, ((j - 1) * 3) - 1] <- sum(
        as.numeric(rank(chain_alpha[snum, i, burnin:niters]) == num_lower) *
          chain_alpha[snum, i, burnin:niters]
      )
      season[i, ((j - 1) * 3)] <- sum(
        as.numeric(rank(chain_alpha[snum, i, burnin:niters]) == num_upper) *
          chain_alpha[snum, i, burnin:niters]
      )
    }
    ## overall season
    oseason$mean[i] <- mean(all_seasons[i, ])
    oseason$lower[i] <- sum(
      as.numeric(rank(all_seasons[i, ]) == num_lower) * all_seasons[i, ]
    )
    oseason$upper[i] <- sum(
      as.numeric(rank(all_seasons[i, ]) == num_upper) * all_seasons[i, ]
    )
    ## fitted values (with CIs)
    new_fitted$mean[i] <- mean(for_fitted[i, ])
    new_fitted$lower[i] <- sum(
      as.numeric(rank(for_fitted[i, ]) == num_lower) * for_fitted[i, ]
    )
    new_fitted$upper[i] <- sum(
      as.numeric(rank(for_fitted[i, ]) == num_upper) * for_fitted[i, ]
    )
  }
  names(season) <- rep(c('mean', 'lower', 'upper'), k)
  ## Time
  if (monthly) {
    time <- year_month
  }
  if (!monthly) {
    time <- 1:n
  }
  ## Calculated fitted values and residuals
  fitted <- trend$mean + oseason$mean
  res <- resp - fitted # calculate the residuals
  ## original call with defaults (see amer package)
  ans <- as.list(match.call())
  frmls <- formals(deparse(ans[[1]]))
  add <- which(!(names(frmls) %in% names(ans)))
  call <- as.call(c(ans, frmls[add]))

  result <- list(
    call = call,
    time = time,
    trend = trend,
    season = season,
    oseason = oseason,
    fitted.values = new_fitted,
    residuals = res,
    n = n,
    chains = list(
      std.error = chain_var_theta,
      std.season = matrix(data = NA, nrow = niters + 1, ncol = k),
      phase = matrix(data = NA, nrow = niters + 1, ncol = k),
      amplitude = matrix(data = NA, nrow = niters + 1, ncol = k)
    )
  )
  for (i in 1:k) {
    # for multiple cycles
    result$chains$std.season[, i] <- chain_lower[, i]
    result$chains$phase[, i] <- chain_phase[, i]
    result$chains$amplitude[, i] <- chain_amp[, i]
  }

  result$chains <- coda::mcmc(
    cbind(
      result$chains$std.error[(burnin + 2):(niters + 1)],
      result$chains$std.season[(burnin + 2):(niters + 1), ],
      result$chains$phase[(burnin + 2):(niters + 1), ],
      result$chains$amplitude[(burnin + 2):(niters + 1), ]
    ),
    start = burnin + 1
  )
  # Add the names
  colnames(result$chains) <- c(
    'std.error',
    paste0('std.season', 1:k),
    paste0('phase', 1:k),
    paste0('amplitude', 1:k)
  )
  result$cycles <- cycles
  class(result) <- c('nsCosinor', class(result))

  result
}

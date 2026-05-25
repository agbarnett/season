#' Forward and Backward Sweep of the Kalman Filter
#'
#' Internal function to do a forward and backward sweep of the Kalman filter,
#' used by [nscosinor()]. For internal use only.
#'
#' @name kalfil
#' @param data a data frame.
#' @param f vector of cycles in units of time.
#' @param vartheta variance for noise.
#' @param w variance of seasonal component.
#' @param tau controls flexibility of trend and season.
#' @param lambda distance between observations.
#' @param cmean used to give a vague prior for the starting values.
#' @returns list with elements: vartheta, w, alpha, amp, phase, cmean
#' @note internal
#' @noRd
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
kalfil <- function(data, f, vartheta, w, tau, lambda, cmean) {
  setup <- kalfil_setup(data, f, vartheta, w, tau, lambda, cmean)
  fwd <- kalfil_forward(setup)
  alpha_j <- kalfil_backward(fwd, setup)
  upd <- kalfil_update_params(alpha_j, fwd, setup)
  list(
    vartheta = upd$vartheta,
    w = upd$w,
    alpha = alpha_j,
    amp = upd$amp,
    phase = upd$phase,
    cmean = upd$cmean
  )
}


# Build the DLM matrices for the Kalman filter:
#   G: state-transition matrix (trend block + one rotation block per cycle)
#   V: process-noise covariance
#   Fvec: observation vector (picks the trend + each season's first state)
#   C_j_init: initial state covariance (diagonal cmean)
# Also: pad `data` with a leading 0 (the t=0 placeholder the sweeps expect).
kalfil_setup <- function(data, f, vartheta, w, tau, lambda, cmean) {
  k <- length(f)
  kk <- 2 * (k + 1)
  n <- length(data)
  data <- c(0, data)
  Fvec <- rep(c(1, 0), k + 1)

  G <- matrix(0, kk, kk)
  G[1, 1] <- 1
  G[1, 2] <- lambda
  G[2, 2] <- 1

  V <- matrix(0, kk, kk)
  V[1, 1] <- (tau[1]^2) * (lambda^3) / 3
  V[1, 2] <- (tau[1]^2) * (lambda^2) / 2
  V[2, 1] <- (tau[1]^2) * (lambda^2) / 2
  V[2, 2] <- (tau[1]^2) * lambda

  for (j in seq_len(k)) {
    G[2 * j + 1, 2 * j + 1] <- 2 * cos(2 * pi / f[j])
    G[2 * j + 1, 2 * j + 2] <- -1
    G[2 * j + 2, 2 * j + 1] <- 1
    V[2 * j + 1, 2 * j + 1] <- (tau[j + 1]^2) * w[j]^2
  }

  C_j_init <- array(0, c(kk, kk, n + 1))
  for (j in seq_len(kk)) {
    C_j_init[j, j, 1] <- cmean[j]
  }

  list(
    data = data,
    k = k,
    kk = kk,
    n = n,
    f = f,
    Fvec = Fvec,
    G = G,
    V = V,
    C_j_init = C_j_init,
    vartheta = vartheta,
    w = w,
    tau = tau
  )
}

# Forward sweep of the Kalman filter. Returns the predictive mean
# `a_j`, filtered mean `p_j`, residuals `e_j`, predictive covariance
# `R_j`, and filtered covariance `C_j` at every timestep.
kalfil_forward <- function(setup) {
  n <- setup$n
  kk <- setup$kk
  data <- setup$data
  Fvec <- setup$Fvec
  G <- setup$G
  V <- setup$V
  vartheta <- setup$vartheta

  C_j <- setup$C_j_init
  a_j <- matrix(0, kk, n + 1)
  p_j <- matrix(0, kk, n + 1)
  e_j <- matrix(0, 1, n + 1)
  R_j <- array(0, c(kk, kk, n + 1))
  p_j[1, 1] <- mean(data[2:(n + 1)])

  for (t in 1:n) {
    a_j[, t + 1] <- G %*% p_j[, t]
    R_j[,, t + 1] <- (G %*% C_j[,, t] %*% t(G)) + V
    e_j[, t + 1] <- data[t + 1] - (t(Fvec) %*% a_j[, t + 1])
    Q_j <- t(Fvec) %*% R_j[,, t + 1] %*% Fvec + (vartheta^2)
    p_j[, t + 1] <- a_j[, t + 1] +
      (R_j[,, t + 1] %*% Fvec %*% qr.solve(Q_j) %*% e_j[, t + 1])
    C_j[,, t + 1] <- R_j[,, t + 1] -
      (R_j[,, t + 1] %*%
        Fvec %*%
        qr.solve(Q_j) %*%
        t(Fvec) %*%
        t(R_j[,, t + 1]))
  }

  list(
    a_j = a_j,
    p_j = p_j,
    e_j = e_j,
    R_j = R_j,
    C_j = C_j
  )
}

# Backward sweep: sample alpha_j from the joint smoothing distribution,
# working from t = n+1 backwards to t = 1. Consumes (n + 1) draws from
# MASS::mvrnorm — preserving that count is required for bit-identical
# RNG state across the refactor.
kalfil_backward <- function(fwd, setup) {
  n <- setup$n
  kk <- setup$kk
  G <- setup$G
  p_j <- fwd$p_j
  C_j <- fwd$C_j
  a_j <- fwd$a_j
  R_j <- fwd$R_j

  alpha_j <- matrix(0, kk, n + 1)
  alpha_j[, n + 1] <- MASS::mvrnorm(
    n = 1,
    mu = p_j[, n + 1],
    Sigma = C_j[,, n + 1]
  )
  for (t in n:1) {
    B_j <- C_j[,, t] %*% t(G) %*% qr.solve(R_j[,, t + 1])
    HH_j <- C_j[,, t] - (B_j %*% R_j[,, t + 1] %*% t(B_j))
    h_j <- p_j[, t] + (B_j %*% (alpha_j[, t + 1] - a_j[, t + 1]))
    alpha_j[, t] <- MASS::mvrnorm(n = 1, mu = h_j, Sigma = t(HH_j))
  }

  alpha_j
}

# Posterior updates and per-cycle summaries. Consumes 1 + k draws from
# rinvgamma (one for vartheta, one per cycle for w) — preserve count
# and order to keep RNG state bit-identical.
kalfil_update_params <- function(alpha_j, fwd, setup) {
  n <- setup$n
  k <- setup$k
  data <- setup$data
  Fvec <- setup$Fvec
  G <- setup$G
  tau <- setup$tau
  f <- setup$f
  C_j <- fwd$C_j
  w <- setup$w

  errors <- compute_squared_errors(
    data_vec = data,
    alpha_j = alpha_j,
    f_vec = Fvec,
    g_mat = G,
    k = k,
    n = n
  )

  shape <- (n / 2) - 1
  scale <- sum(errors$se) / 2
  vartheta <- sqrt(rinvgamma(1, shape, scale))

  shape <- ((n - 1) / 2) - 1
  for (j in seq_len(k)) {
    scale <- sum(errors$alpha_se[, j]) / 2
    w[j] <- sqrt(rinvgamma(1, shape, scale) / (tau[j + 1]^2))
  }

  amp <- numeric(k)
  phase <- numeric(k)
  for (j in seq_len(k)) {
    s <- alpha_j[2 * j + 1, 1:n]
    pgr <- peri(s)
    loc <- which.min(abs(pgr$c - f[j]))
    amp[j] <- pgr$amp[loc]
    phase[j] <- pgr$phase[loc]
  }

  # NB: this loop is *not* equivalent to `rowMeans(apply(C_j, 3, diag))`.
  # The two summation orders differ by ~2^-53 per element, which would
  # propagate into the next iteration's prior and drift the MCMC chain.
  kk <- setup$kk
  cmean <- numeric(kk)
  for (j in seq_len(kk)) {
    cmean[j] <- mean(C_j[j, j, ])
  }

  list(vartheta = vartheta, w = w, amp = amp, phase = phase, cmean = cmean)
}

# AAFT (Amplitude Adjusted Fourier Transform), copied from Matlab code Jan 2012

#' Amplitude Adjusted Fourier Transform (AAFT)
#'
#' Generates random linear surrogate data of a time series with the same
#' second-order properties.
#'
#' The AAFT uses phase-scrambling to create a surrogate of the time series that
#' has a similar spectrum (and hence similar second-order statistics). The AAFT
#' is useful for testing for non-linearity in a time series, and is used by
#' `nonlintest`.
#'
#' @param data a vector of equally spaced numeric observations (time series).
#' @param nsur the number of surrogates to generate (1 or more).
#' @returns a matrix of the `nsur` surrogates.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Kugiumtzis D (2000) Surrogate data test for nonlinearity
#' including monotonic transformations, *Phys. Rev. E*, vol 62 no. 1, 2000.
#' \doi{doi:10.1103/PhysRevE.62.R25}
#' @examples
#'
#' \donttest{
#' aaft(CVD$cvd, nsur = 1)
#' surr <- aaft(CVD$cvd, nsur = 1)
#' plot(CVD$cvd, type = "l")
#' lines(surr[ ,1], col = "red")
#' }
#'
#' @export
aaft <- function(data, nsur) {
  n <- length(data)
  # The following gives the rank order, ixV
  ixV <- order(data)
  # ranks
  rxV <- rank(data)
  # smallest to largest
  oxV <- data[ixV]

  # ===== AAFT algorithm
  surrogates <- matrix(data = 0, n, nsur)

  for (count in 1:nsur) {
    # Rank ordering white noise with respect to data
    # random N(0,1)
    rV <- stats::rnorm(n)
    # in order, smallest to largest
    orV <- sort(rV)
    yV <- orV[rxV]
    # cor(yV,data,method='spearman') # Not run, should be one
    # Phase randomisation (Fourier Transform): yV -> yftV ----
    if (n %% 2 == 0) {
      n2 <- n / 2
    } else {
      n2 <- (n - 1) / 2
    }
    # FFT
    tmpV <- stats::fft(yV, 2 * n2)
    # magnitude
    magnV <- abs(tmpV)
    # phases
    fiV <- Arg(tmpV)
    # random phases
    rfiV <- stats::runif(n2 - 1) * 2 * pi
    nfiV <- c(0, rfiV, fiV[n2 + 1], -rev(rfiV))
    # New Fourier transformed data with only the phase changed
    tmpV <- c(magnV[1:(n2 + 1)], rev(magnV[2:n2]))
    # complex exponential
    c.exp <- cos(nfiV) + 1i * sin(nfiV)
    # Transform back to time domain;
    tmpV <- tmpV * c.exp
    # 3-step AAFT;
    yftV <- Re(stats::fft(tmpV, inverse = TRUE))
    # Rank ordering data with respect to yftV
    iyftV <- rank(yftV)
    # surrogates is the AAFT surrogate of data
    surrogates[, count] <- oxV[iyftV]
  } # end of loop

  surrogates
}

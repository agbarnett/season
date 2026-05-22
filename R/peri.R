#' Periodogram
#'
#' Estimated periodogram using the fast Fourier transform (`fft`).
#'
#' @param data a data frame.
#' @param adjmean subtract the mean from the series before calculating the
#' periodogram (default=TRUE).
#' @param plot plot the estimated periodogram (default=TRUE).
#' @returns a list with the following elements:
#'   * peri: periodogram, I(\eqn{\omega}).
#'   * f: frequencies in radians, \eqn{\omega}.
#'   * c: frequencies in cycles of time, \eqn{2\pi/\omega}.
#'   * amp: amplitude periodogram.
#'   * phase: phase periodogram.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#' \donttest{
#' p = peri(CVD$cvd)
#' }
#'
#' @export
peri <- function(data, adjmean = TRUE, plot = TRUE) {
  xaxis <- yaxis <- NULL

  if (adjmean) {
    adjust <- mean(data)
  } else {
    adjust <- 0
  }
  n <- length(data)
  n_fft <- (n / 2) + 1
  if (n %% 2 != 0) {
    data <- c(data, mean(data))
  } # taper odd length series with mean of data
  first <- stats::fft(data - adjust) / (n / 2) # Fast Fourier Transform
  real_part <- Re(first[1:n_fft])
  imaginary_part <- -Im(first[1:n_fft])
  peri <- (n / 2) * (real_part^2 + imaginary_part^2) # Periodogram
  freq_radians <- (0:(n / 2)) * pi * 2 / n # Frequencies in radians
  freq_cycles <- pi * 2 / freq_radians # Frequencies in cycles
  freq_cycles[1] <- NA
  amp <- sqrt(real_part^2 + imaginary_part^2)
  phase <- vector(mode = "numeric", length = n_fft) # phase in scale [0,2pi]
  inner <- 2:(n_fft - 1)
  phase[inner] <- atan2(imaginary_part[inner], real_part[inner]) %% (2 * pi)
  ## Plot
  if (plot) {
    df_plot_1 <- data.frame(
      xaxis = freq_radians,
      yaxis = peri,
      type = 'Radians'
    )
    df_plot_2 <- data.frame(
      xaxis = freq_cycles[2:n_fft],
      yaxis = peri[2:n_fft],
      type = 'Cycles'
    )
    df_plot <- rbind(df_plot_1, df_plot_2)
    gplot <- ggplot2::ggplot(
      df_plot,
      ggplot2::aes(
        xaxis,
        yaxis,
        ymin = 0,
        ymax = yaxis
      )
    ) +
      ggplot2::geom_linerange() +
      ggplot2::theme_bw() +
      ggplot2::xlab('Frequency in radians or cycles') +
      ggplot2::ylab('Periodogram') +
      ggplot2::facet_wrap(~type, scales = 'free_x')
    print(gplot)
  }
  # return
  return(list(
    peri = peri,
    f = freq_radians,
    c = freq_cycles,
    amp = amp,
    phase = phase
  ))
}

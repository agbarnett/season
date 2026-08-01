#' Periodogram
#'
#' Estimated periodogram using the fast Fourier transform (`fft`).
#'
#' @param data a data frame.
#' @param adjmean subtract the mean from the series before calculating the
#' periodogram (default=TRUE).
#' @param plot `r lifecycle::badge("deprecated")` Use [autoplot.peri()] on the
#'   returned object instead.
#' @returns an object of class `"peri"` (a tibble) with the columns:
#'   * peri: periodogram, I(\eqn{\omega}).
#'   * freq_radians: frequencies in radians, \eqn{\omega}.
#'   * freq_cycles: frequencies in cycles of time, \eqn{2\pi/\omega}.
#'   * amp: amplitude periodogram.
#'   * phase: phase periodogram.
#'
#'   Pass the result to [autoplot()][autoplot.peri()] to draw the plot.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [autoplot.peri()]
#' @examples
#' \donttest{
#' p <- peri(CVD$cvd)
#' autoplot(p)
#' }
#'
#' @export
peri <- function(data, adjmean = TRUE, plot = lifecycle::deprecated()) {
  if (lifecycle::is_present(plot)) {
    lifecycle::deprecate_warn(
      when = "0.3.17",
      what = "peri(plot)",
      details = c(
        "`peri()` now returns a classed object you can pass to `autoplot()`.",
        i = "Use `autoplot(peri(data))` to draw the plot."
      )
    )
  } else {
    plot <- FALSE
  }

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

  result <- tibble::tibble(
    peri = peri,
    freq_radians = freq_radians,
    freq_cycles = freq_cycles,
    amp = amp,
    phase = phase
  )

  result <- tibble::new_tibble(
    x = result,
    class = "peri"
  )

  ## Deprecated side-effect: still respect `plot = TRUE` if user passed it
  if (isTRUE(plot)) {
    print(autoplot(result))
  }

  result
}

#' Plot the periodogram from [peri()]
#'
#' Produce a ggplot of the periodogram in both radians and cycles. The
#' returned ggplot can be extended with `+` (e.g. `+ ggplot2::theme_minimal()`).
#'
#' @param object a `"peri"` object produced by [peri()].
#' @param ... unused, for S3 generic compatibility.
#' @returns a ggplot object.
#' @author Nicholas Tierney
#' @seealso [peri()]
#' @examples
#' \donttest{
#' p <- peri(CVD$cvd)
#' autoplot(p)
#' autoplot(p) + ggplot2::theme_minimal()
#' }
#' @export
autoplot.peri <- function(object, ...) {
  check_if_peri(object)
  xaxis <- yaxis <- NULL
  n_fft <- length(object$peri)
  df_plot <- rbind(
    data.frame(
      xaxis = object$freq_radians,
      yaxis = object$peri,
      type = "Radians"
    ),
    data.frame(
      xaxis = object$freq_cycles[2:n_fft],
      yaxis = object$peri[2:n_fft],
      type = "Cycles"
    )
  )
  ggplot2::ggplot(
    df_plot,
    ggplot2::aes(xaxis, yaxis, ymin = 0, ymax = yaxis)
  ) +
    ggplot2::geom_linerange() +
    ggplot2::theme_bw() +
    ggplot2::xlab("Frequency in radians or cycles") +
    ggplot2::ylab("Periodogram") +
    ggplot2::facet_wrap(~type, scales = "free_x")
}

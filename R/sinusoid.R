#' Plot a Sinusoid
#'
#' Plots a sinusoid over 0 to 2\eqn{\pi}.
#'
#' Sinusoidal curves are useful for modelling seasonal data. A sinusoid is
#' plotted using the equation: \eqn{A\cos(ft-P), t=0,\ldots,2 \pi}, where
#' \eqn{A} is the amplitude, \eqn{f} is the frequency, \eqn{t} is time and
#' \eqn{P} is the phase.
#'
#' @param amplitude the amplitude of the sinusoid (its maximum value).
#' @param frequency the frequency of the sinusoid in 0 to 2\eqn{\pi} (number of
#' cycles).
#' @param phase the phase of the sinusoid (location of the peak).
#' @returns tibble of sinusoidal wave of given amplitude, frequency, and phase.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' s_n <- sinusoid(
#'   amplitude = 1,
#'   frequency = 1,
#'   phase = 1
#'   )
#' s_n
#' # plot it
#' autoplot(s_n)
#' @export
sinusoid <- function(amplitude, frequency, phase) {
  time <- seq(from = 0, to = 2 * pi, by = pi / 1000)
  sinusoid <- amplitude * cos(time * frequency - phase)
  result <- tibble::tibble(
    time = time,
    sinusoid = sinusoid
  )
  tibble::new_tibble(
    x = result,
    class = "sinusoid"
  )
}

#' @export
autoplot.sinusoid <- function(object, ...) {
  ggplot2::ggplot(
    object,
    ggplot2::aes(
      x = time,
      y = sinusoid
    )
  ) +
    ggplot2::geom_line() +
    ggplot2::geom_hline(
      yintercept = 0,
      lty = 2
    ) +
    ggplot2::scale_x_continuous(
      breaks = c(0, pi, 2 * pi),
      labels = c("0", expression(pi), expression(2 * pi))
    ) +
    ggplot2::labs(
      x = "Time (radians)",
      y = NULL
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme_sub_panel(
      grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::theme_sub_axis(
      text = ggplot2::element_text(size = 13)
    )
}

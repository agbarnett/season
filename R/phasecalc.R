#' Phase from Cosinor Estimates
#'
#' Calculate the phase given the estimated sine and cosine values from a
#' cosinor model. Returns the phase in radians, in the range \eqn{[0,2\pi)}.
#' The phase is the peak in the sinusoid. Applies [atan2()] over a branching
#' workflow for each coordinate. See \url{https://en.wikipedia.org/wiki/Atan2}
#' for more information.
#'
#' @param cosine estimated cosine value from a cosinor model.
#' @param sine estimated sine value from a cosinor model.
#' @returns the estimated phase in radians.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Fisher, N.I. (1993) *Statistical Analysis of Circular
#' Data*. Cambridge University Press, Cambridge. Page 31.
#' @examples
#' # pi/2
#' phasecalc(cosine=0, sine=1)
#'
#' @export phasecalc
phasecalc <- function(cosine, sine) {
  atan2(sine, cosine) %% (2 * pi)
}

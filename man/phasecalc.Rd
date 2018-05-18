\name{phasecalc}
\alias{phasecalc}
\title{Phase from Cosinor Estimates}
\description{Calculate the phase given the estimated sine and cosine values from a cosinor model.}
\usage{phasecalc(cosine, sine)}
\arguments{
  \item{cosine}{estimated cosine value from a cosinor model.}
  \item{sine}{estimated sine value from a cosinor model.}
}
\details{Returns the phase in radians, in the range \eqn{[0,2\pi)}. The
  phase is the peak in the sinusoid.
}
\value{
  \item{phaser}{Estimated phase in radians.}
}
\references{Fisher, N.I. (1993) \emph{Statistical Analysis of Circular Data}. Cambridge University Press, Cambridge. Page 31.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{\donttest{
phasecalc(cosine=0, sine=1) # pi/2
}
}

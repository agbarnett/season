# phasecalc.R
# calculate phase given cosine and sine estimates
# returns results on scale [0,2pi]
# equivalent to page 31 of Fisher



#' Phase from Cosinor Estimates
#' 
#' Calculate the phase given the estimated sine and cosine values from a
#' cosinor model.
#' 
#' Returns the phase in radians, in the range \eqn{[0,2\pi)}. The phase is the
#' peak in the sinusoid.
#' 
#' @param cosine estimated cosine value from a cosinor model.
#' @param sine estimated sine value from a cosinor model.
#' @return \item{phaser}{Estimated phase in radians.}
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Fisher, N.I. (1993) \emph{Statistical Analysis of Circular
#' Data}. Cambridge University Press, Cambridge. Page 31.
#' @examples
#' 
#' phasecalc(cosine=0, sine=1) # pi/2
#' 
#' @export phasecalc
phasecalc<-function(cosine,sine){
 if(cosine==0){cosine=cosine+0.000000001} # avoid zeros
 div<- sine/cosine
 if (cosine>=0){phaser<-atan(div)}
 if (cosine<0&sine>=0){phaser<-atan(div)+pi}
 if (cosine<0&sine<0){phaser<-atan(div)-pi}
# put in 0 to 2pi range
 if (phaser<0) { phaser<-phaser+(2*pi)} 
 if (phaser>(2*pi)) { phaser<-phaser-(2*pi)}
 return(phaser)
}

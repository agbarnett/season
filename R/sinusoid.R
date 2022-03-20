#' Plot a Sinusoid
#' 
#' Plots a sinusoid over 0 to 2\eqn{\pi}.
#' 
#' Sinusoidal curves are useful for modelling seasonal data. A sinusoid is
#' plotted using the equation: \eqn{A\cos(ft-P), t=0,\ldots,2 \pi}, where
#' \eqn{A} is the amplitude, \eqn{f} is the frequency, \eqn{t} is time and
#' \eqn{P} is the phase.
#' 
#' @param amplitude the amplitude of the sinsuoid (its maximum value).
#' @param frequency the frequency of the sinusoid in 0 to 2\eqn{\pi} (number of
#' cycles).
#' @param phase the phase of the sinusoid (location of the peak).
#' @param \dots additional arguments passed to the plot.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @examples
#' sinusoid(amplitude=1, frequency=1, phase=1)
#' 
#' @export sinusoid
sinusoid<-function(amplitude,frequency,phase,...){
  time<-seq(0,2*pi,pi/1000);
  sinusoid<-amplitude*cos(time*frequency-phase)
  par(las=1)
  plot(time,sinusoid,type='l',xaxt='n',xlab='Time (radians)',ylab='',...)
  lines(range(time),c(0,0),lty=2)
  axis(side=1,at=c(0,pi,2*pi),font=5,labels=c('0','p','2p'))
}
#sinusoid(amplitude=1,frequency=1,phase=1)

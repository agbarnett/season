## summary.nsCosinor.R
## Summarise results from nsCosinor


#' Summary for a Non-stationary Cosinor
#' 
#' The default summary method for a \code{nsCosinor} object produced by
#' \code{nscosinor}.
#' 
#' The amplitude describes the average height of each seasonal cycle, and the
#' phase describes the location of the peak. The results for the phase are
#' given in radians (0 to 2\eqn{\pi}), they can be transformed to the time
#' scale using the \code{invyrfraction} making sure to first divide by
#' 2\eqn{\pi}.
#' 
#' The larger the standard deviation for the seasonal cycles, the greater the
#' non-stationarity. This is because a larger standard deviation means more
#' change over time.
#' 
#' @aliases summary.nsCosinor 
#' @param object a \code{nsCosinor} object produced by \code{nscosinor}.
#' @param \dots further arguments passed to or from other methods.
#' @return \item{cycles}{vector of cycles in units of time, e.g., for a six and
#' twelve month pattern \code{cycles=c(6,12)}.} \item{niters}{total number of
#' MCMC samples.} \item{burnin}{number of MCMC samples discarded as a burn-in.}
#' \item{tau}{vector of smoothing parameters, tau[1] for trend, tau[2] for 1st
#' seasonal parameter, tau[3] for 2nd seasonal parameter, etc.}
#' \item{stats}{summary statistics (mean and confidence interval) for the
#' residual standard deviation, the standard deviation for each seasonal cycle,
#' and the amplitude and phase for each cycle.}
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{nscosinor}, \code{plot.nsCosinor}
#' @export
summary.nsCosinor<-function(object, ...){

  ## Checks
  if (class(object)!="nsCosinor"){stop("Object must be of class 'nsCosinor'")} 

  ## basic variables
  k<-length(object$cycles);
  cycles<-object$cycles;

### split combined chain into old style (Dec 2011)
  new=list()
  new$chains$std.error=object$chains[,1] # added
  new$chains$std.season=object$chains[,2] # added

  ## Statistics ###
  s.std.error<-summary(new$chains$std.error)
  l<-as.numeric(s.std.error$quantiles[1])
  u<-as.numeric(s.std.error$quantiles[5])
  m<-as.numeric(s.std.error$statistics[1])
  errorstats<-c(m,l,u)
  if(k==1){
    s.std.season<-summary(new$chains$std.season)
    wstats<-matrix(ncol=1,nrow=k)
    l<-as.numeric(s.std.season$quantiles[1])
    u<-as.numeric(s.std.season$quantiles[5])
    m<-as.numeric(s.std.season$statistics[1])
    wstats<-c(m,l,u)
    ampstats<-matrix(ncol=1,nrow=k)
    phasestats<-matrix(ncol=1,nrow=k)
    new$chains$amplitude=object$chains[,4] # added
    new$chains$phase=object$chains[,3] # added
    s.amp<-summary(new$chains$amplitude)
    l<-as.numeric(s.amp$quantiles[1])
    u<-as.numeric(s.amp$quantiles[5])
    m<-as.numeric(s.amp$statistics[1])
    ampstats<-c(m,l,u)
    pstat<-ciPhase(as.vector(new$chains$phase))
    phasestats<-c(pstat$mean,pstat$lower,pstat$upper)
  } # end of k=1
  if(k>=2){
    wstats<-matrix(ncol=3,nrow=k)
    for (index in 1:k){ 
      s.std.season<-summary(object$chains[,index+1])
      l<-as.numeric(s.std.season$quantiles[1])
      u<-as.numeric(s.std.season$quantiles[5])
      m<-as.numeric(s.std.season$statistics[1])
      wstats[index,]<-c(m,l,u)
    }
    ampstats<-matrix(ncol=3,nrow=k)
    phasestats<-matrix(ncol=3,nrow=k)
    for (index in 1:k){ 
      s.amp<-summary(object$chains[,index+1+(2*k)])
      l<-as.numeric(s.amp$quantiles[1])
      u<-as.numeric(s.amp$quantiles[5])
      m<-as.numeric(s.amp$statistics[1])
      ampstats[index,]<-c(m,l,u)
      phase.chain<-as.vector(object$chains[,index+1+k])
      pstat<-ciPhase(phase.chain)
      phasestats[index,]<-c(pstat$mean,pstat$lower,pstat$upper)
    }
  } # end of k>=2

  ## store the statistics
  ret<-list()
  ret$cycles<-cycles
  ret$niters<-object$call$niters
  ret$burnin<-object$call$burnin
  ret$tau<-object$call$tau
  ret$stats$errorstats<-errorstats
  ret$stats$wstats<-wstats
  ret$stats$ampstats<-ampstats
  ret$stats$phasestats<-phasestats
  class(ret)<-'summary.nsCosinor'
  ret # uses print.summary.nsCosinor
} # end of function

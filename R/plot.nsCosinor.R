## plot.nsCosinor.R
## Plots results from nsCosinor using ggplot2


#' Plot the Results of a Non-stationary Cosinor
#' 
#' Plots the trend and season(s) from a \code{nsCosinor} object produced by
#' \code{nscosinor}.
#' 
#' The code produces the season(s) and trend estimates.
#' 
#' @param x a \code{nsCosinor} object produced by \code{nscosinor}.
#' @param \dots further arguments passed to or from other methods.
#' @return \item{gplot}{A plot of class \code{ggplot}}
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{nscosinor}
#' @export 
plot.nsCosinor<-function(x, ...){

  ## basic variables
  cycles<-x$cycles;
  k<-length(cycles);
  month<-(12*(x$time-floor(x$time)))+1

  # season
  smat<-as.matrix(x$season)
  # loop through seasons
  for (index in 1:k){
    mean<-smat[,(index*3)-2]
    lower<-smat[,(index*3)-1]
    upper<-smat[,(index*3)]
    type<-paste("Season, cycle=",cycles[index],sep="")
    this.frame=data.frame(time=x$time,mean=mean,lower=lower,upper=upper,type=type)
    if(index==1){season.frame=this.frame}else{season.frame=rbind(season.frame,this.frame)}
  }

  # trend
  trend.frame=data.frame(time=x$time,mean=x$trend$mean,lower=x$trend$lower,upper=x$trend$upper,type='Trend')
  plot.frame=rbind(trend.frame,season.frame)

  # plot with ribbon
  gplot = ggplot(plot.frame, aes(time, mean)) +
    geom_ribbon(aes(ymin=lower, ymax=upper, alpha=5), show.legend = FALSE)+
    geom_line()+
    theme_bw()+
    xlab('Time') +
    ylab(' ') +
    facet_grid(type~.,scales='free_y')
#  print(gplot)

  # return
  return(gplot)
}

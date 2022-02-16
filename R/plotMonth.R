# plotMonth.R
# function to plot monthly results by month
# assumes the data are in order
# assumes there are numeric variables for month and year



#' Plot Results by Month
#' 
#' Plots results by month.
#' 
#' Assumes the data frame contains variables called year and month.
#' 
#' @param data a data frame.
#' @param resp response variable to plot.
#' @param panels number of panels to use in plot (1 or 12). 12 gives one panel
#' per month, 1 plots all the months in the same panel.
#' @param \dots further arguments passed to or from other methods.
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @references Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal
#' Health Data}. Springer.
#' @examples
#' \donttest{
#' data(CVD)
#' plotMonth(data=CVD, resp='cvd', panels=12)
#' }
#' 
#' @export 
plotMonth<-function(data,resp,panels=12, ...){

  year <- yaxis <- Month <- NULL # Setting some variables to NULL first (for R CMD check)
  
  if (panels!=1&panels!=12){stop("panels must be 1 or 12")}
  data$yaxis=subset(data,select=resp)[,1]
  
  # 12 panels
  data$Month=factor(data$month,levels=1:12,labels=month.abb) # to change facet_wrap labels
  if(panels==12){
  gplot = ggplot(data, aes(year, yaxis)) +
    geom_line()+
    theme_bw()+
    xlab(' ') +        
    ylab(resp) +        
    facet_wrap(~Month)
  print(gplot)
  }
  
  # 1 panels
  if(panels==1){
    gplot = ggplot(data, aes(year, yaxis,color=Month)) +
      geom_line()+
      theme_bw()+
      xlab(' ') +        
      ylab(resp)         
    print(gplot)
  }
  
}

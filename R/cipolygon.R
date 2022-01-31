# cipolygon.R
# function to draw CI polygon

#' Function to Draw CI Polygon
#' 
#' Internal function to draw a confidence interval for multiple times as a grey
#' area. For internal use only.
#' 
#' @name cipolygon
#' @param time x-axis.
#' @param lower lower limit of the confidence level.
#' @param upper upper limit of the confidence level.
#' @author Adrian Barnett \email{a.barnett@@qut.edu.au}
cipolygon<-function(time,lower,upper){
 n<-length(time)
 points<-matrix(nrow=n*2,ncol=2)
 points[1:n,1:2]<-cbind(time,upper)
 points[(n+1):(2*n),1:2]<-cbind(time[n:1],lower[n:1])
 polygon(x=points[,1],y=points[,2],col='gray',border=NA)
}

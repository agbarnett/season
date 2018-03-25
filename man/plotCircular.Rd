\name{plotCircular}
\alias{plotCircular}
\title{Circular plot using segments}
\description{A circular plot useful for visualising monthly or weekly data.}
\usage{plotCircular(area1,area2=NULL,spokes=NULL,scale=0.8,
       labels,stats=TRUE,dp=1,clockwise=TRUE,spoke.col='black',
       lines=FALSE,centrecirc=0.03, main="", xlab="", ylab="",
       pieces.col=c("white","gray"), length=FALSE, legend=TRUE,
       auto.legend=list(x="bottomright",fill=NULL, labels=NULL, title=""),\dots)
}
\arguments{
  \item{area1}{variable to plot, the area of the segments (or petals) are proportional to this variable.}
  \item{area2}{2nd variable to plot (optional), the area of the segments are plotted in gray.}
  \item{spokes}{spokes that overlay segments, for example standard
    errors (optional).}
  \item{scale}{scale the overall size of the segments (default:0.8).}
  \item{labels}{optional labels to appear at the ends of the segments
    (there should be as many labels as there are \code{area1}).}
  \item{stats}{put area values at the ends of the segments, default:TRUE.}
  \item{dp}{decimal places for statistics, default:1.}
  \item{clockwise}{plot in a clockwise direction, default:TRUE.}
  \item{spoke.col}{spoke colour, default:black.}
  \item{lines}{add dotted lines to separate petals, default:FALSE.}
  \item{centrecirc}{controls the size of the circle at the centre of
    the plot, default:0.03.}
  \item{main}{title for plot, default:blank}
  \item{xlab}{x axis label, default:blank}
  \item{ylab}{y axis label, default:blank}
  \item{pieces.col}{colours for circular pieces, default:\sQuote{white}
    for 1st and \sQuote{gray} for second variable. Note that a list of
    available colours may be found with \sQuote{colors()}}
  \item{length}{make the length of the segments proportional to the
    dependent variable, default:FALSE}
  \item{legend}{whether to include legend or not, default:TRUE when
    plotting two variables}
  \item{auto.legend}{list of parameters for legend, see \code{\link{legend}}}
  \item{\dots}{additional arguments to \code{\link{plot}} and/or
    \code{\link{legend}}. See \code{\link{par}} for more details}
}
\details{A circular plot can be useful for spotting the shape of the
  seasonal pattern. This function can be used to plot any circular
  patterns, e.g., weekly or monthly. The number of segments will be
  the length of the variable \code{area1}.
  
  The plots are also called rose diagrams, with the segments then
  called \sQuote{petals}.}
\references{Fisher, N.I. (1993) \emph{Statistical Analysis of
    Circular Data}. Cambridge University Press, Cambridge.}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{
# months (dummy data)
plotCircular(area1=seq(1,12,1),scale=0.7,labels=month.abb,dp=0)
# weeks (random data)
daysoftheweek<-c('Monday','Tuesday','Wednesday','Thursday','Friday',
'Saturday','Sunday')
weekfreq<-table(round(runif(100,min=1,max=7)))
plotCircular(area1=weekfreq,labels=daysoftheweek,dp=0)
# Observed number of AFL players with expected values
data(AFL)
plotCircular(area1=AFL$players,area2=AFL$expected,scale=0.72,
  labels=month.abb,dp=0,lines=TRUE,legend=FALSE)
plotCircular(area1=AFL$players,area2=AFL$expected,scale=0.72,
  labels=month.abb,dp=0,lines=TRUE, pieces.col=c("green","red"),
  auto.legend=list(labels=c("Obs","Exp"),title="# players"),
  main="Observed and Expected AFL players")
}
}

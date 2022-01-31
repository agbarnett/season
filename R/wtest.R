# wtest.R
# Walter's test of seasonality
# April 2009



#' Walter and Elwood's Test of Seasonality
#' 
#' Tests for a seasonal pattern in Binomial data.
#' 
#' A test of whether monthly data has a sinusoidal seasonal pattern. The test
#' has low power compared with the \code{\link{cosinor}} test.
#' 
#' @param cases variable name for cases (\dQuote{successes}).
#' @param offset variable name for at-risk population (\dQuote{trials}).
#' @param data data frame (optional).
#' @param alpha significance level (default=0.05).
#' @return \item{test}{test statistic.} \item{pvalue}{p-value.}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @references Walter, S.D., Elwood, J.M. (1975) A test for seasonality of
#' events with a variable population at risk. \emph{British Journal of
#' Preventive and Social Medicine} 29, 18--21.
#' 
#' Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}.
#' Springer.
#' @examples
#' 
#' data(stillbirth)
#' # tabulate the total number of births and the number of stillbirths
#' freqs = table(stillbirth$month,stillbirth$stillborn)
#' data = list()
#' data$trials = as.numeric(freqs[,1]+freqs[,2])
#' data$success = as.numeric(freqs[,2])
#' # test for a seasonal pattern in stillbirth
#' test = wtest(cases='success', offset='trials', data=data)
#' 
#' @export wtest
wtest<-function(cases,offset,data,alpha=0.05){
  xcases=with(data,get(cases)) # replace attach
  xoffset=with(data,get(offset)) # replace attach
  j<-(0:11)/12
  N=sum(xcases)
  M=sum(xoffset)
  W=sum(sqrt(xcases))
# observed values
  c=sqrt(xcases)*cos(j*2*pi)
  cbar=sum(c/W)
  s=sqrt(xcases)*sin(j*2*pi)
  sbar=sum(s/W)
  d=sqrt( (cbar^2) + (sbar^2) )
# expected values
  D=sum(sqrt(xoffset))
  c=sqrt(xoffset)*cos(j*2*pi)
  Ecbar=sum(c/D)
  s=sqrt(xoffset)*sin(j*2*pi)
  Esbar=sum(s/D)
# variance	
  D=sum(sqrt(N*xoffset/M))
  c=cos(j*2*pi)*cos(j*2*pi)
  Vc=0.25*sum(c)/(D^2)
  s=sin(j*2*pi)*sin(j*2*pi)
  Vs=0.25*sum(s)/(D^2)
# test statistic
  # criti
  test=(((cbar-Ecbar)^2)/Vc)+(((sbar-Esbar)^2)/Vs)
  q=1-alpha
  xnull=qchisq(q,df=2) # null limit (critical value)
  pvalue<-1-pchisq(test,df=2)
  cat('Walter`s test\n')
  cat('test statistic',test,'p-value',pvalue,'\n')
  return(list(test=test,pvalue=pvalue))
}

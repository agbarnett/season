# nonlintest.R
# Dec 2011
# Time domain statistic for non-linearity (copied from Matlab code)
# Bootstraps using AAFT methods then compares observed third order moment with expected
# For more details see: Barnett & Wolff, A Time-Domain Test for Some Types of Nonlinearity, IEEE transactions on signal processing, Vol 53, No 1, January 2005
## Inputs
# data - series as a column vector
# n.lag - number of third order moment lags to compute
# n.boot - number of bootstrap replications
# alpha - level of test
## Outputs
# jackstats - test of null hypothesis using double bootstrap
#             [outside,standardised,upperlimit,pvalue,H0(accept/reject)]
# (outside - total area outside of null hypothesis limits)
## Other functions called
# third - 3rd order moment
# aaft - AAFT algorithm



#' Test of Non-linearity of a Time Series
#' 
#' A bootstrap test of non-linearity in a time series using the third-order
#' moment.
#' 
#' The test uses \code{aaft} to create linear surrogates with the same
#' second-order properties, but no (third-order) non-linearity. The third-order
#' moments (\code{third}) of these linear surrogates and the actual series are
#' then compared from lags 0 up to \code{n.lag} (excluding the skew at the
#' co-ordinates (0,0)). The bootstrap test works on the overall area outside
#' the limits, and gives an indication of the overall non-linearity. The plot
#' using \code{region} shows those co-ordinates of the third order moment that
#' exceed the null hypothesis limits, and can be a useful clue for guessing the
#' type of non-linearity. For example, a large value at the co-ordinates (0,1)
#' might be caused by a bi-linear series \eqn{X_t=\alpha
#' X_{t-1}\varepsilon_{t-1} +\varepsilon_t}.
#' 
#' @param data a vector of equally spaced numeric observations (time series).
#' @param n.lag the number of lags tested using the third-order moment, maximum
#' = length of time series.
#' @param n.boot the number of bootstrap replications (suggested minimum of
#' 100; 1000 or more would be better).
#' @param alpha statistical significance level of test (default=0.05).
#' @return Returns an object of class \dQuote{nonlintest} with the following
#' parts: \item{region}{the region of the third order moment where the test
#' exceeds the limits (up to \code{n.lag}).} \item{n.lag}{the maximum lag
#' tested using the third-order moment.} \item{stats}{a list of following
#' statistics for the area outside the test limits:} \item{outside}{the total
#' area outside of limits (summed over the whole third-order moment).}
#' \item{stan}{the total area outside the limits divided by its standard
#' deviation to give a standardised estimate.} \item{median}{the median area
#' outside the test limits.} \item{upper}{the (1-\code{alpha})th percentile of
#' the area outside the limits.} \item{pvalue}{Bootstrap p-value of the area
#' outside the limits to test if the series is linear.} \item{test}{Reject the
#' null hypothesis that the series is linear (TRUE/FALSE).}
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso \code{print.nonlintest}, \code{plot.nonlintest}
#' @references Barnett AG & Wolff RC (2005) A Time-Domain Test for Some Types
#' of Nonlinearity, \emph{IEEE Transactions on Signal Processing}, vol 53,
#' pages 26--33
#' @examples
#' \donttest{
#' data(CVD)
#' \dontrun{test.res = nonlintest(data=CVD$cvd, n.lag=4, n.boot=1000)}
#' }
#' 
#' @export nonlintest
nonlintest=function(data,n.lag,n.boot,alpha=0.05){

# Initial variables;
n=length(data);

# Difference the series;
Xmean=mean(data);
Xdiff=data-Xmean;

# Get the series 3rd order moment for later use;
Xtemp=third(data=Xdiff,n.lag=n.lag,centre=FALSE,outmax=FALSE,plot=FALSE);
reglags=(n.lag+1):(n.lag+n.lag+1);
Xthird=Xtemp$third[reglags,reglags];
Xthird[1,1]=0; # Remove skewness;

# Get n.boot*3 surrogates using the AAFT method
# First n.boot for initial limits 2nd & 3rd n.boot for bootstrap limits
aaftsers=aaft(Xdiff,nsur=n.boot*3);

# Run each series through the third order moment;
aaftthird=array(0,dim=c(n.lag+1,n.lag+1,n.boot*3));
for (k in 1:(n.boot*3)){
   sersthird=third(aaftsers[,k],n.lag,centre=FALSE,outmax=FALSE,plot=FALSE);
   aaftthird[,,k]=sersthird$third[reglags,reglags];
}
aaftthird[1,1,]=0; # Remove skewness;

# Get the (1-alpha)th centile at each coordinate and difference from the series;
clevel_l=alpha/2;
clevel_u=1-(alpha/2);
mcent_l1=matrix(0,n.lag+1,n.lag+1);
mcent_u1=matrix(0,n.lag+1,n.lag+1);
mcent_l2=matrix(0,n.lag+1,n.lag+1);
mcent_u2=matrix(0,n.lag+1,n.lag+1);
for (r in 0:n.lag){
   for (s in r:n.lag){
      if ((r+s)>0){
         pts1=aaftthird[r+1,s+1,1:n.boot]; # First limits
         pts2=aaftthird[r+1,s+1,(n.boot+1):(2*n.boot)]; # Second limits
         mcent_l1[r+1,s+1]=as.numeric(quantile(pts1,probs=clevel_l));
         mcent_u1[r+1,s+1]=as.numeric(quantile(pts1,probs=clevel_u));
         mcent_l2[r+1,s+1]=as.numeric(quantile(pts2,probs=clevel_l));
         mcent_u2[r+1,s+1]=as.numeric(quantile(pts2,probs=clevel_u));
      }
   }
}
uppert=upper.tri(matrix(0,n.lag+1,n.lag+1),diag=T)
diff_l=(Xthird-mcent_l1)*uppert; # Just get for s<r;
diff_u=(Xthird-mcent_u1)*uppert; # Just get for s<r;

# Show points significantly higher or lower than limits;
region_u=matrix(0,n.lag+1,n.lag+1)
region_l=matrix(0,n.lag+1,n.lag+1)
index=diff_u>0
region_u[index]=diff_u[index];
index=diff_l<0
region_l[index]=diff_l[index];
region=region_u+region_l;
# Total area exceeding limits;
outside=sum(sum(abs(region)));
#total=((n.lag+1)*(n.lag+2)/2)-1; # Total number of points tested

# Double bootstrap statistic using 2nd set of limits on first set of data;
# 3rd series - limits from 2nd;
jackstat=vector(mode='numeric',length=n.boot);
for (jack in ((2*n.boot)+1):(n.boot*3)){
## Percentile statistic;
   diffjack_u=(aaftthird[,,jack]-mcent_u2)*uppert;
   diffjack_l=(aaftthird[,,jack]-mcent_l2)*uppert;
   jregion_u=matrix(0,n.lag+1,n.lag+1)
   jregion_l=matrix(0,n.lag+1,n.lag+1)
   jindex=diffjack_u>0
   jregion_u[jindex]=diffjack_u[jindex];
   jindex=diffjack_l<0
   jregion_l[jindex]=diffjack_l[jindex];
   jregion=jregion_u+jregion_l;
# Total area exceeding limits;
   jackstat[jack-(2*n.boot)]=sum(sum(abs(jregion)));
}

jackstd=sd(jackstat);
stan=outside/jackstd;
upperjack=quantile(jackstat,probs=1-alpha);
medianjack=median(jackstat);
pjack=sum(outside<jackstat)/n.boot;

# return stats and plot details
if(outside>upperjack){testjack=TRUE}else{testjack=FALSE}
jackstats=list()
jackstats$outside=outside
jackstats$stan=stan
jackstats$median=medianjack
jackstats$upper=upperjack
jackstats$pvalue=pjack
jackstats$test=testjack
to.return=list()
to.return$stats=jackstats
to.return$region=region
to.return$diff_l=diff_l
to.return$diff_u=diff_u
to.return$n.lag=n.lag
class(to.return)='nonlintest'
return(to.return)
} # end of function

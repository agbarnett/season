\name{season-internal}

%%\name{cipolygon-internal}
%%%%%\alias{cipolygon}
%%\title{Function to draw CI polygon}
% \description{Internal function to draw a confidence interval for multiple times as a grey area. For internal use only.}
% \usage{cipolygon(time,lower,upper)}
% \arguments{
%   \item{time}{x-axis.}
%   \item{lower}{lower limit of the confidence level.}
%   \item{upper}{upper limit of the confidence level.}
% }
% \author{Adrian Barnett \email{a.barnett@qut.edu.au}}

%%\name{flagleap}
%%%%%\alias{flagleap}
%%\title{Count the number of days in the month}
% \description{Counts the number of days per month given a range of dates. Used to adjust monthly count data for the at-risk time period. For internal use only.}
% \usage{flagleap(data,report=TRUE)}
% \arguments{
%   \item{data}{data.}
%   \item{report}{produce a brief report on the range of time used (default=TRUE).}
% }
% \details{The data should contain the numeric variable called
% \sQuote{year} as a 4 digit year (e.g., 1973).}
% \value{
%   \item{year}{year (4 digits).}
%   \item{month}{month (2 digits).}
%   \item{ndaysmonth}{number of days in the month (either 28, 29, 30 or 31).}
% }
% \author{Adrian Barnett \email{a.barnett@qut.edu.au}}
% \examples{
% data(CVD)
% days<-flagleap(data=CVD)
% }

%%\name{kalfil-internal}
%%%%%\alias{kalfil}
%%\title{Forward and backward sweep of the Kalman filter}
% \description{Internal function to do a forward and backward sweep of the Kalman filter, used by \code{nscosinor}. For internal use only.}
% \usage{kalfil(data,f,vartheta,w,tau,lambda,cmean)}
% \arguments{
%   \item{data}{a data frame.}
%   \item{f}{vector of cycles in units of time.}
%   \item{vartheta}{variance for noise.}
%   \item{w}{variance of seasonal component.}
%   \item{tau}{controls flexibility of trend and season.}
%   \item{lambda}{distance between observations.}
%   \item{cmean}{used to give a vague prior for the starting values.}
% }
% \author{Adrian Barnett \email{a.barnett@qut.edu.au}}

% \name{nochars-internal}
%%%%%\alias{nochars}
%%\title{Remove letters and characters from a string}
% \description{Remove letters and characters from a string to leave only numbers. Removes all letters (upper and lower case) and the characters \dQuote{.}, \dQuote{(} and \dQuote{)}. For internal use only.}
% \usage{nochars(text)}
% \arguments{
%   \item{text}{text string.}
% }
% \author{Adrian Barnett \email{a.barnett@qut.edu.au}}
% \examples{
% nochars('adrian.(0)')
% }
% \name{rinvgamma-internal}
%%%%%\alias{rinvgamma}
% %%\title{Random inverse gamma distribution}
% \description{Internal function to simulate a value from an inverse Gamma distribution, used by \code{nscosinor}. See the MCMCpack library. For internal use only.}
% \usage{rinvgamma(n,shape,scale=1)}
% \arguments{
%   \item{n}{number of observations.}
%   \item{shape}{Gamma shape parameter.}
%   \item{scale}{Gamma scale parameter (default=1).}
% }

\title{Internal Season Functions}
\description{
  Internal Season functions
}
\details{
  These are not to be called by the user
}
\keyword{ internal }

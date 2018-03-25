\name{casecross}
\alias{casecross}
\title{Case--crossover analysis to control for seasonality}
\description{Fits a time-stratified case--crossover to regularly spaced time series data. The function is not suitable for irregularly spaced individual data. The function only uses a time-stratified design, and other designs such as the symmetric bi-directional design, are not available.}
\usage{casecross(formula, data, exclusion=2, stratalength=28, matchdow=FALSE,
                 usefinalwindow=FALSE, matchconf='', confrange=0, stratamonth=FALSE)}
\arguments{
  \item{formula}{formula. The dependent variable should be an integer count (e.g., daily number of deaths).}
  \item{data}{data set as a data frame.}
  \item{exclusion}{exclusion period (in days) around cases, set to 2 (default). Must be positive and smaller than \code{stratalength}.}
  \item{stratalength}{length of stratum in days, set to 28 (default).}
  \item{matchdow}{match case and control days using day of the week (TRUE/default=FALSE). This matching is in addition to the strata matching.}
  \item{usefinalwindow}{use the last stratum in the time series, which is likely to contain less days than all the other strata (TRUE/default=FALSE).}
  \item{matchconf}{match case and control days using an important confounder (optional; must be in quotes). \code{matchconf} is the variable to match on. This matching is in addition to the strata matching.}
  \item{confrange}{range of the confounder within which case and control days will be treated as a match (optional). Range = \code{matchconf} (on case day) \eqn{+/-} \code{confrange}.}
  \item{stratamonth}{use strata based on months, default=FALSE. Instead of a fixed strata size when using \code{stratalength}.}
}
\details{The case--crossover method compares \dQuote{case} days when events occurred (e.g.,
  deaths) with control days to look for differences in exposure that might explain
  differences in the number of cases. Control days are selected to be nearby to case
  days, which means that only recent changes in the independent variable(s) are compared. By only
  comparing recent values, any long-term or seasonal variation in the dependent and independent variable(s) can be
  eliminated. This elimination depends on the definition of nearby and on the seasonal
  and long-term patterns in the independent variable(s).

  Control and case days are only compared if they are in the same stratum. The stratum is controlled by \code{stratalength}, the default value is 28 days, so that cases and controls are compared in four week sections.
  Smaller stratum lengths provide a closer control for season, but reduce the available number of controls.
  Control days that are close to the case day may have similar levels of the independent variable(s). To reduce this correlation it is possible to place an \code{exclusion} around the cases.
  The default is 2, which means that the smallest gap between a case and control will be 3 days.

  To remove any confounding by day of the week it is possible to additionally match by day of the week (\code{matchdow}), although this usually reduces the number of available controls. This matching is in addition to the strata matching.

  It is possible to additionally match case and control days by an important confounder (\code{matchconf}) in order to remove its effect. Control days are matched to case days if they are: 
  i) in the same strata, ii) have the same day of the week if \code{matchdow=TRUE}, iii) have a value of \code{matchconf} that is within plus/minus \code{confrange} of the value of \code{matchconf} on the case day. If the range is set too narrow then the number of available controls will become too small, which in turn means the number of case days with at least one control day is compromised.

  The method uses conditional logistic regression (see \code{\link{coxph}} and so the parameter estimates are odds ratios.)

  The code assumes that the data frame contains a date variable (in \code{\link{Date}} format) called \sQuote{date}.}
\value{
  \item{call}{the original call to the casecross function.} 
  \item{c.model}{conditional logistic regression model of class \code{coxph}.}
  \item{ncases}{total number of cases.}
  \item{ncasedays}{number of case days with at least one control day.}
  \item{ncontroldayss}{average number of control days per case day.}
}
\references{Janes, H., Sheppard, L., Lumley, T. (2005) Case-crossover analyses of air pollution exposure data:
  Referent selection strategies and their implications for bias. \emph{Epidemiology} 16(6), 717--726.

  Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}. Springer.}
\seealso{\code{summary.casecross}, \code{coxph}}
\author{Adrian Barnett \email{a.barnett<at>qut.edu.au}}
\examples{
\donttest{
# cardiovascular disease data
data(CVDdaily)
CVDdaily=subset(CVDdaily,date<=as.Date('1987-12-31')) # subset for example
# Effect of ozone on CVD death
model1 = casecross(cvd ~ o3mean+tmpd+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily)
summary(model1)
# match on day of the week
model2 = casecross(cvd ~ o3mean+tmpd,matchdow=TRUE, data=CVDdaily)
summary(model2)
# match on temperature to within a degree
model3 = casecross(cvd ~ o3mean+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily,
                   matchconf='tmpd', confrange=1)
summary(model3)
}
}

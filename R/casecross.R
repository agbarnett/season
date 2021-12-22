## casecross.R
## time-stratified case-crossover
## Oct 2011
## assumes date variable is called 'date'
## quicker version



#' Case--crossover Analysis to Control for Seasonality
#' 
#' Fits a time-stratified case--crossover to regularly spaced time series data.
#' The function is not suitable for irregularly spaced individual data. The
#' function only uses a time-stratified design, and other designs such as the
#' symmetric bi-directional design, are not available.
#' 
#' The case--crossover method compares \dQuote{case} days when events occurred
#' (e.g., deaths) with control days to look for differences in exposure that
#' might explain differences in the number of cases. Control days are selected
#' to be nearby to case days, which means that only recent changes in the
#' independent variable(s) are compared. By only comparing recent values, any
#' long-term or seasonal variation in the dependent and independent variable(s)
#' can be eliminated. This elimination depends on the definition of nearby and
#' on the seasonal and long-term patterns in the independent variable(s).
#' 
#' Control and case days are only compared if they are in the same stratum. The
#' stratum is controlled by \code{stratalength}, the default value is 28 days,
#' so that cases and controls are compared in four week sections.  Smaller
#' stratum lengths provide a closer control for season, but reduce the
#' available number of controls.  Control days that are close to the case day
#' may have similar levels of the independent variable(s). To reduce this
#' correlation it is possible to place an \code{exclusion} around the cases.
#' The default is 2, which means that the smallest gap between a case and
#' control will be 3 days.
#' 
#' To remove any confounding by day of the week it is possible to additionally
#' match by day of the week (\code{matchdow}), although this usually reduces
#' the number of available controls. This matching is in addition to the strata
#' matching.
#' 
#' It is possible to additionally match case and control days by an important
#' confounder (\code{matchconf}) in order to remove its effect. Control days
#' are matched to case days if they are: i) in the same strata, ii) have the
#' same day of the week if \code{matchdow=TRUE}, iii) have a value of
#' \code{matchconf} that is within plus/minus \code{confrange} of the value of
#' \code{matchconf} on the case day. If the range is set too narrow then the
#' number of available controls will become too small, which in turn means the
#' number of case days with at least one control day is compromised.
#' 
#' The method uses conditional logistic regression (see \code{\link{coxph}} and
#' so the parameter estimates are odds ratios.)
#' 
#' The code assumes that the data frame contains a date variable (in
#' \code{\link{Date}} format) called \sQuote{date}.
#' 
#' @param formula formula. The dependent variable should be an integer count
#' (e.g., daily number of deaths).
#' @param data data set as a data frame.
#' @param exclusion exclusion period (in days) around cases, set to 2
#' (default). Must be greater than or equal to zero and smaller than
#' \code{stratalength}.
#' @param stratalength length of stratum in days, set to 28 (default).
#' @param matchdow match case and control days using day of the week
#' (TRUE/default=FALSE). This matching is in addition to the strata matching.
#' @param usefinalwindow use the last stratum in the time series, which is
#' likely to contain less days than all the other strata (TRUE/default=FALSE).
#' @param matchconf match case and control days using an important confounder
#' (optional; must be in quotes). \code{matchconf} is the variable to match on.
#' This matching is in addition to the strata matching.
#' @param confrange range of the confounder within which case and control days
#' will be treated as a match (optional). Range = \code{matchconf} (on case
#' day) \eqn{+/-} \code{confrange}.
#' @param stratamonth use strata based on months, default=FALSE. Instead of a
#' fixed strata size when using \code{stratalength}.
#' @return \item{call}{the original call to the casecross function.}
#' \item{c.model}{conditional logistic regression model of class \code{coxph}.}
#' \item{ncases}{total number of cases.} \item{ncasedays}{number of case days
#' with at least one control day.} \item{ncontroldayss}{average number of
#' control days per case day.}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @seealso \code{summary.casecross}, \code{coxph}
#' @references Janes, H., Sheppard, L., Lumley, T. (2005) Case-crossover
#' analyses of air pollution exposure data: Referent selection strategies and
#' their implications for bias. \emph{Epidemiology} 16(6), 717--726.
#' 
#' Barnett, A.G., Dobson, A.J. (2010) \emph{Analysing Seasonal Health Data}.
#' Springer.
#' @examples
#' \donttest{# cardiovascular disease data
#' data(CVDdaily)
#' CVDdaily = subset(CVDdaily, date<=as.Date('1987-12-31')) # subset for example
#' # Effect of ozone on CVD death
#' model1 = casecross(cvd ~ o3mean+tmpd+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily)
#' summary(model1)
#' # match on day of the week
#' model2 = casecross(cvd ~ o3mean+tmpd, matchdow=TRUE, data=CVDdaily)
#' summary(model2)
#' # match on temperature to within a degree
#' model3 = casecross(cvd ~ o3mean+Mon+Tue+Wed+Thu+Fri+Sat, data=CVDdaily,
#'                    matchconf='tmpd', confrange=1)
#' summary(model3)
#' }
#' 
#' @export casecross
casecross = function(formula, data, exclusion = 2, stratalength = 28,
          matchdow = FALSE, usefinalwindow = FALSE, matchconf = '',
          confrange = 0, stratamonth = FALSE){
 outcome  =  dow  =  case  = timex  =  dow.x  =  dow.y  =  matchday.x  =  matchday.y  =  windownum.x  =  windownum.y  =  NULL # Setting some variables to NULL first (for R CMD check)
 thisdata = data
 ## Checks
 if (class(thisdata$date)!= "Date"){
  stop("date variable must be in date format, see ?Dates")}
 if (exclusion<0){stop("Minimum value for exclusion is zero")}
 parts = paste(formula)
 dep = parts[2] # dependent variable
 indep = parts[3] # dependent variable
 if (length(formula)<= 2){stop("Must be at least one independent variable")}
 ## original call with defaults (see amer package)
 ans  =  as.list(match.call())
 frmls  =  formals(deparse(ans[[1]]))
 add  =  which(!(names(frmls) %in% names(ans)))
 call = as.call(c(ans, frmls[add]))
 thisdata$dow = as.numeric(format(thisdata$date,'%w'));
 ## Slim down the data
 f = as.formula(paste(parts[2],parts[1],parts[3],'+date+dow'))
 if (substr(matchconf,1,1)!= ""){
  f = as.formula(paste(dep, "~", indep, '+date+dow+', matchconf))
 }
 datatouse = model.frame(f, data = thisdata, na.action = na.omit) # remove cases with missing covariates
 ## Check for irregularly spaced data
 if(any(diff(datatouse$date) > 1)){
   cat('Note, irregularly spaced data...\n')
   cat('...check your data for missing days\n')
 }
 datediff = as.numeric(datatouse$date) - min(as.numeric(datatouse$date)) # use minimum data in entire sample (error fixed 2 September 2018, second data was not 'datatouse')
 time = as.numeric(datediff)+1 # used as strata number

 ## Create strata
 if (stratamonth == TRUE){
  month = as.numeric(format(datatouse$date,'%m'));
  year = as.numeric(format(datatouse$date,'%Y'));
  matchday = as.numeric(format(datatouse$date,'%d'));
  yrdiff = year-min(year);
  windownum = (yrdiff*12)+month;
 }
 if (stratamonth == FALSE){
  ## Get the earliest time and difference all dates from this time
  ## Increase strata windows in jumps of 'stratalength'
  windownum = floor(datediff/stratalength)+1
  nwindows = floor(nrow(thisdata)/stratalength)+1
  matchday = datediff-((windownum-1)*stratalength)+1 # Day number in strata
  ## Exclude the last window if it is less than 'stratalength'
  lastwindow = datatouse[datatouse$windownum == nwindows,]
  if (nrow(lastwindow)>0){ # only apply to data sets with some data in the final window
   lastlength = max(time[windownum == nwindows]) -
    min(time[windownum == nwindows])+1
   if (lastlength<stratalength&usefinalwindow == FALSE) {datatouse = datatouse[windownum < nwindows,] }
  }
 }
 ## Create the case data
 n = nrow(datatouse)
 cases = datatouse
 cases$case = 1 # binary indicator of case
 cases$timex = 1 # Needed for conditional logistic regression
 cases$windownum = windownum
 cases$time = time
 cases$diffdays = NA
 cases$matchday = matchday
 posout = sum(as.numeric(names(datatouse) == as.character(f[2]))*
       (1:ncol(datatouse))) # get the position of the dependent variable
 cases$outcome = datatouse[, c(posout)]
 # October 2011, removed nonzerocases
 # Create a case number for matching
 if (substr(matchconf, 1, 1) == ""){
  cases.tomerge = subset(cases, select = c(matchday,time,outcome,windownum,dow))}
 if (substr(matchconf, 1, 1)!= ""){
   also = sum(as.numeric(names(cases) == matchconf)*(1:length(names(cases))))
   cases.tomerge = subset(cases,
              select = c(matchday,time,outcome,windownum,dow,also))
 }
 ncases = nrow(cases)
 cases.tomerge$casenum = 1:ncases
 # Duplicate case series to make controls
 maxwindows = max(cases$windownum)
 rowstorep = NULL
 casenum = NULL
 # Fix for missing windows (thanks to Yuming)
 windowrange = as.numeric(levels(as.factor(windownum)))
 for (k in windowrange){ # loop through every window
  small = min(cases$time[cases$windownum == k])
  large = max(cases$time[cases$windownum == k])
  these = rep(small:large, large-small+1)
  rowstorep = c(rowstorep, these)
  casenum = c(casenum, these[order(these)])
 }
 # create controls from cases
 controls = cases[rowstorep,] # can fall over if there's missing data
 controls = subset(controls, select = c(-case, -timex, -time, -outcome))
 # Replace case number
 controls$casenum = casenum
 # Merge cases with controls by case number
 controls = merge(controls, cases.tomerge, by = 'casenum')
 controls = controls[controls$windownum.x == controls$windownum.y,] # must be in same stratum window
 controls$case = 0 # binary indicator of case
 controls$timex = 2 # Needed for conditional logistic regression
 controls$diffdays = abs(controls$matchday.x - controls$matchday.y)
 controls = controls[controls$diffdays > exclusion,] # remove the exclusion window
 # match on day of the week
 if (matchdow == TRUE){controls = controls[controls$dow.x == controls$dow.y,]}
 # match on a confounder
 if (substr(matchconf,1,1) != ""){
   one =  paste(matchconf,'.x',sep = '')
   two =  paste(matchconf,'.y',sep = '')
   find1 = grep(one,names(controls))
   find2 = grep(two,names(controls))
   matchdiff = abs(controls[,find1]-controls[,find2])
   controls = controls[matchdiff<= confrange,]
   controls = subset(controls,select = c(-casenum,-dow.x,-dow.y,-matchday.x,-matchday.y,-windownum.x,-windownum.y,-find1,-find2))
   findc = sum(as.numeric(names(cases) == matchconf)*(1:length(names(cases))))
   final.cases = subset(cases,select = c(-dow,-matchday,-windownum,-findc))
 }
 if (substr(matchconf,1,1) == ""){
  controls = subset(controls,select = c(-casenum,-dow.x,-dow.y,-matchday.x,-matchday.y,-windownum.x,-windownum.y))
  final.cases = subset(cases,select = c(-dow,-matchday,-windownum))
 }
 finished = rbind(final.cases, controls)
 ## Remove empty controls
 finished = finished[finished$outcome > 0,]
 ## Count the number of control days without a case day, and the total number of cases
 onlycntl = finished[finished$case == 0,]
 ncases = nrow(table(onlycntl$time))
 which.times = unique(onlycntl$time)
 extra.only = final.cases[final.cases$time%in%which.times,]
 ncontrols = round(mean(as.numeric(table(onlycntl$time))),1)
 ## Run the conditional logistic regression
 finalformula = as.formula(paste('Surv(timex,case)~',indep,'+strata(time)'))
 c.model = coxph(finalformula,
         weights = outcome,
         data = finished,method = c("breslow"))
 toret = list()
 toret$call = call
 toret$c.model = c.model
 class(toret$c.model) = "coxph"
 toret$ncases = sum(extra.only$outcome)
 toret$ncasedays = ncases
 toret$ncontroldays = ncontrols
 class(toret) = 'casecross'
 return(toret)
}

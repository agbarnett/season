# invyrfraction.R
# convert fraction of the year into a date (day and month)
# month on a scale of [1,13)
# type =  monthly/weekly/daily
# Jan 2014 (minor update Aug 2020)



#' Inverse Fraction of the Year or Hour
#' 
#' Inverts a fraction of the year or hour to a useful time scale.
#' 
#' Returns the day and month (for \code{daily}) or fraction of the month (for
#' \code{monthly}) given a fraction of the year. Assumes a year length of
#' 365.25 days for \code{daily}. When using \code{monthly} the 1st of January
#' is 1, the 1st of December is 12, and the 31st of December is 12.9. For
#' \code{hourly} it returns the fraction of the 24-hour clock starting from
#' zero (midnight).
#' 
#' @param frac a vector of fractions of the year, all between 0 and 1.
#' @param type \dQuote{\code{daily}} for dates, \dQuote{\code{monthly}} for
#' months, \dQuote{\code{hourly}} for hours.
#' @param text add an explanatory text to the returned value (TRUE) or return a
#' number (FALSE).
#' @return \item{daym}{date (day and month for \code{daily}) or fractional
#' month (for \code{monthly}) or fractional of the 24-hour clock (for
#' \code{hourly}).}
#' @author Adrian Barnett \email{a.barnett<at>qut.edu.au}
#' @examples
#' 
#' invyrfraction(c(0, 0.5, 0.99), type='daily')
#' invyrfraction(c(0, 0.5, 0.99), type='monthly')
#' invyrfraction(c(0, 0.5, 0.99), type='hourly')
#' 
#' @export invyrfraction
invyrfraction<-function(frac,type='daily',text=TRUE){
  n<-length(frac)
  if(sum(frac<0)+sum(frac>1)>0){stop('Fraction must be between 0 and 1')}
  if (type=='daily'){
     yrlength<-365.25; 
     day<-(frac*yrlength)+1;
     day=day-(365*as.numeric(day>365)); # avoid values > 365
     day=pmax(day,1); # avoid values < 1
     date<-strptime(day,'%j');
     day<-as.numeric(format(date,'%d')); # Day of the month as decimal number (01?31)
     month<-format(date,'%B'); # Month name
     if (text==TRUE){daym<-paste('Month =',month,', day =',day)}
     if (text==FALSE){
        monthnum<-as.numeric(format(date,'%m')); # Month number
        mnthlength<-c(31,28.25,31,30,31,30,31,31,30,31,30,31)
        daym<-monthnum+((day-1)/mnthlength[monthnum])
     } # 
  }
  if (type=='weekly'){
    week<-(frac*52)+1;
    if (text==TRUE){daym<-paste('Week =',round(week,1))}
    if (text==FALSE){daym<-week}
  }
  if (type=='monthly'){
     month<-(frac*12)+1;
     if (text==TRUE){daym<-paste('Month =',round(month,1))}
     if (text==FALSE){daym<-month}
  }
  if (type=='hourly'){
    month<-(frac*24); # do not add one for hour, start at 00:00
    if (text==TRUE){daym<-paste('Hour =',round(month,1))}
    if (text==FALSE){daym<-month}
  }
  return(daym)
}


# yrfraction.R
# fraction of the year for a date, includes leap year
# type = 'monthly', 'weekly' or 'daily' (default)
# Jan 2014

#' Fraction of the Year
#'
#' Calculate the fraction of the year for a date variable (after accounting for
#' leap years) or for month.
#'
#' Returns the fraction of the year in the range [0,1).
#'
#' @param date a date variable if type="daily", or an integer between 1 and 12
#'   if type="monthly".
#' @param type "daily" for dates, or "monthly" for months.
#' @return the fraction of the year.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#'
#' # create fractions for the start, middle and end of the year
#' date = as.Date(c(0, 181, 364), origin='1991-01-01')
#' # create fractions based on these dates
#' yrfraction(date)
#' yrfraction(1:12, type='monthly')
#'
#' @export yrfraction
yrfraction <- function(date, type = 'daily') {
  if (type == 'daily') {
    if (!inherits(date, "Date")) {
      stop("Date variable for annual data must be in date format, see ?Dates")
    }
    year <- as.numeric(format(date, '%Y'))
    # last day in December
    lastday <- ISOdate(year, 12, 31)
    # Day of year as decimal number (001-366)
    day <- as.numeric(format(date, '%j'))
    yrlength <- as.numeric(format(lastday, '%j'))
    yrfrac <- (day - 1) / yrlength
  }
  if (type == 'weekly') {
    if (max(date) > 53 || min(date) < 1) {
      stop("Date variable for weekly data must be month integer (1 to 53)")
    }
    yrfrac <- (date - 1) / (365.25 / 7)
  }
  if (type == 'monthly') {
    if (max(date) > 12 || min(date) < 1) {
      stop("Date variable for monthly data must be month integer (1 to 12)")
    }
    yrfrac <- (date - 1) / 12
  }
  return(yrfrac)
}

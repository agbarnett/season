#' Fraction of the Year
#'
#' Calculate the fraction of the year for a date variable (after accounting for
#' leap years) or for month.
#'
#' Returns the fraction of the year in the range [0,1).
#'
#' @param date a date variable if type="daily", or an integer between 1 and 12
#'   if type="monthly".
#' @param type One of "daily" (default) for dates, "monthly" for months, or
#'   "weekly" for weeks.
#' @returns the fraction of the year.
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#'
#' # create fractions for the start, middle and end of the year
#' date <- as.Date(c(0, 181, 364), origin = '1991-01-01')
#' # create fractions based on these dates
#' yrfraction(date)
#' yrfraction(1:12, type = 'monthly')
#'
#' @export
yrfraction <- function(date, type = c("daily", "weekly", "monthly")) {
  type <- rlang::arg_match(type)

  yrfrac <- switch(
    type,
    daily = yrfrac_daily(date),
    weekly = yrfrac_weekly(date),
    monthly = yrfrac_monthly(date),
  )

  yrfrac
}

yrfrac_daily <- function(date) {
  if (!inherits(date, "Date")) {
    stop("Date variable for annual data must be in date format, see ?Dates")
  }
  year <- as.numeric(format(date, '%Y'))
  # last day in December
  lastday <- ISOdate(year, 12, 31)
  # Day of year as decimal number (001-366)
  day <- as.numeric(format(date, '%j'))
  year_length <- as.numeric(format(lastday, '%j'))
  yrfrac <- (day - 1) / year_length
  yrfrac
}

yrfrac_weekly <- function(date) {
  if (max(date) > 53 || min(date) < 1) {
    stop("Date variable for weekly data must be month integer (1 to 53)")
  }
  yrfrac <- (date - 1) / (365.25 / 7)
  yrfrac
}

yrfrac_monthly <- function(date) {
  if (max(date) > 12 || min(date) < 1) {
    stop("Date variable for monthly data must be month integer (1 to 12)")
  }
  yrfrac <- (date - 1) / 12
  yrfrac
}

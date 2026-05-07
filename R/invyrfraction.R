# invyrfraction.R
# convert fraction of the year into a date (day and month)
# month on a scale of [1,13)
# type =  monthly/weekly/daily
# Jan 2014 (minor update Aug 2020)

#' Inverse Fraction of the Year or Hour
#'
#' Inverts a fraction of the year or hour to a useful time scale.
#'
#' Returns the day and month (for "daily") or fraction of the month (for
#' "monthly") given a fraction of the year. Assumes a year length of
#' 365.25 days for "daily". When using "monthly" the 1st of January
#' is 1, the 1st of December is 12, and the 31st of December is 12.9. For
#' "hourly" it returns the fraction of the 24-hour clock starting from
#' zero (midnight).
#'
#' @param frac a vector of fractions of the year, all between 0 and 1.
#' @param type "daily" for dates, "monthly" for months, "hourly" for hours,
#'   "weekly" for weeks.
#' @param text add an explanatory text to the returned value (TRUE) or return a
#' number (FALSE).
#' @return the date (day and month for "daily"), fractional month (for
#'   "monthly"), or fraction of the 24-hour clock (for "hourly").
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#'
#' invyrfraction(c(0, 0.5, 0.99), type='hourly')
#' invyrfraction(c(0, 0.5, 0.99), type='daily')
#' invyrfraction(c(0, 0.5, 0.99), type='weekly')
#' invyrfraction(c(0, 0.5, 0.99), type='monthly')
#'
#' @export invyrfraction
invyrfraction <- function(
  frac,
  type = c("daily", "monthly", "hourly", "weekly"),
  text = TRUE
) {
  type <- rlang::arg_match(type)

  n <- length(frac)
  if (sum(frac < 0) + sum(frac > 1) > 0) {
    stop('Fraction must be between 0 and 1')
  }

  daym <- switch(
    type,
    daily = daym_from_daily(frac, text),
    weekly = daym_from_weekly(frac, text),
    monthly = daym_from_monthly(frac, text),
    hourly = daym_from_hourly(frac, text)
  )

  return(daym)
}

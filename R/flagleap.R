# Jan 2014
#' Flag leap years and months in a range of dates
#'
#' Counts the number of days per month given a range of dates. Used to adjust
#' monthly count data for the at-risk time period. For internal use only.
#'
#' The data should contain the numeric variable called "year" as a 4
#' digit year (e.g., 1973).
#'
#' @param data Data frame with a numeric variable called "year" as a 4 digit
#'   year (e.g., 1973).
#' @param report Logical. Produce a brief report on the range of time used?
#' Default is TRUE.
#' @param matchin Expand result to match start and end dates, otherwise only
#'   dates in the data will be returned. Default is FALSE.
#' @returns Data frame with columns:
#'   * year: year (4 digits),
#'   * month: month (2 digits),
#'   * n_days_month: number of days in the month (either 28, 29, 30 or 31).
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @note internal
#' @noRd
#' @examples
#' head(CVD)
#' flagleap(CVD)
#' flagleap(CVD, matchin = TRUE)
flagleap <- function(data, report = TRUE, matchin = FALSE) {
  year_month <- data$year + ((data$month - 1) / 12)
  year_start <- min(data$year)
  year_stop <- max(data$year)
  # start on 1st Jan
  date_start <- as.numeric(ISOdate(year_start, 1, 1)) / (60 * 60 * 24)
  # stop on 31st Dec
  date_stop <- as.numeric(ISOdate(year_stop, 12, 31)) / (60 * 60 * 24)
  n_days <- date_stop - date_start + 1
  if (report) {
    cat("Total number of days = ", n_days, "\n")
  }
  seconds_in_day <- 60 * 60 * 24
  z <- (date_start:date_stop) * seconds_in_day

  date_converted <- as.POSIXct(z, origin = "1970-01-01")
  # number of days per year
  n_days_year <- table(format(date_converted, '%Y'))
  # number of days per month (per year)
  n_days_month <- table(format(date_converted, '%Y/%m'))
  year <- as.numeric(substr(names(n_days_month), 1, 4))
  month <- as.numeric(substr(names(n_days_month), 6, 7))
  days <- data.frame(
    year = year,
    month = month,
    n_days_month = as.numeric(n_days_month)
  )

  # Match start and end times
  if (matchin) {
    year_month_days <- days$year + ((days$month - 1) / 12)
    index <- year_month_days >= min(year_month) &
      year_month_days <= max(year_month)
    if (report) {
      cat('Number of index times ', sum(index), '\n')
    }
    days <- days[index, ]
  }
  return(days)
}

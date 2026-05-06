# function to flag leap years/months in a range of dates
# Jan 2014

#' Flag leap years and months in a range of dates
#'
#' Counts the number of days per month given a range of dates. Used to adjust
#' monthly count data for the at-risk time period. For internal use only.
#'
#' The data should contain the numeric variable called "year" as a 4
#' digit year (e.g., 1973).
#'
#' @param data data.
#' @param report produce a brief report on the range of time used
#' (default=TRUE).
#' @param matchin expand the result to match the start and end dates, otherwise
#' only dates in the data will be returned (default=FALSE).
#' @return a data frame with the following columns:
#'   * year: year (4 digits).
#'   * month: month (2 digits).
#'   * ndaysmonth: number of days in the month (either 28, 29, 30 or 31).
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @note internal
#' @noRd
#' @examples
#' flagleap(CVD)
flagleap <- function(data, report = TRUE, matchin = FALSE) {
  n <- nrow(data)
  # used later
  yrmon <- data$year + ((data$month - 1) / 12)
  startyr <- min(data$year)
  stopyr <- max(data$year)
  # start on 1st Jan
  startdate <- as.numeric(ISOdate(startyr, 1, 1)) / (60 * 60 * 24)
  # stop on 31st Dec
  stopdate <- as.numeric(ISOdate(stopyr, 12, 31)) / (60 * 60 * 24)
  ndays <- stopdate - startdate + 1
  if (report) {
    cat("Total number of days = ", ndays, "\n")
  }
  z <- vector(length = ndays, mode = 'numeric')
  index <- 0
  for (i in startdate:stopdate) {
    # loop through start to stop dates in days
    index <- index + 1
    # convert to seconds
    z[index] <- i * (60 * 60 * 24)
  }
  # convert to a date
  conv <- as.POSIXct(z, origin = "1970-01-01")
  # number of days per year
  ndaysyear <- table(format(conv, '%Y'))
  # number of days per month (per year)
  ndaysmonth <- table(format(conv, '%Y/%m'))
  year <- as.numeric(substr(names(ndaysmonth), 1, 4))
  month <- as.numeric(substr(names(ndaysmonth), 6, 7))
  days <- as.data.frame(cbind(year, month, as.numeric(ndaysmonth)))
  names(days) <- c('year', 'month', 'ndaysmonth')
  # Match start and end times
  if (matchin) {
    yrmon.days <- days$year + ((days$month - 1) / 12)
    index <- yrmon.days >= min(yrmon) & yrmon.days <= max(yrmon)
    if (report) {
      cat('Number of index times ', sum(index), '\n')
    }
    days <- days[index, ]
  }
  # Finish
  return(days)
}

# example
# days<-flagleap(data=CVD)

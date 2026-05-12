#' Keep Month Numbers
#'
#' This is an internal function that only keeps the numbers of a string.
#'   This is used in the process of transferring months names to numbers.
#'
#' @param x character text
#'
#' @returns character text with only numbers.
#' @note internal
#' @noRd
keep_month_numbers <- function(x) {
  as.numeric(gsub(pattern = "[^0-9]", replacement = "", x = x))
}

daym_from_daily <- function(frac, text) {
  year_length <- 365.25
  day <- (frac * year_length) + 1
  # avoid values > 365
  day <- day - (365 * as.numeric(day > 365))
  # avoid values < 1
  day <- pmax(day, 1)
  date <- strptime(day, '%j')
  # Day of the month as decimal number (01?31)
  daym <- as.numeric(format(date, '%d'))
  # Month name
  month <- format(date, '%B')
  if (text) {
    daym <- paste('Month =', month, ', day =', daym)
  }
  if (!text) {
    daym <- day
  }
  daym
}

daym_from_weekly <- function(frac, text) {
  week <- (frac * 52) + 1
  if (text) {
    daym <- paste('Week =', round(week, 1))
  }
  if (!text) {
    daym <- week
  }
  daym
}

daym_from_monthly <- function(frac, text) {
  month <- (frac * 12) + 1
  if (text) {
    daym <- paste('Month =', round(month, 1))
  }
  if (!text) {
    daym <- month
  }
  daym
}

daym_from_hourly <- function(frac, text) {
  month <- (frac * 24) # do not add one for hour, start at 00:00
  if (text) {
    daym <- paste('Hour =', round(month, 1))
  }
  if (!text) {
    daym <- month
  }
  daym
}

quantile_dbl <- function(x, probs) as.numeric(stats::quantile(x, probs = probs))

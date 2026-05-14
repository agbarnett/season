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


inform_irregularly_spaced <- function(x) {
  ## Check for irregularly spaced data
  if (any(diff(x) > 1)) {
    cat('Note, irregularly spaced data...\n')
    cat('...check your data for missing days\n')
  }
}


window_num_stratamonth <- function(date) {
  year <- as.numeric(format(date, '%Y'))
  year_diff <- year - min(year)
  month <- as.numeric(format(date, '%m'))
  window_num <- (year_diff * 12) + month
  window_num
}

parse_indep <- function(formula) {
  # dependent would be:
  # paste(formula)[3]

  # independent variable
  paste(formula)[3]
}

hourly_frac <- function(resp) {
  number <- as.numeric(format(resp, '%H')) +
    (as.numeric(format(resp, '%M')) / 60) +
    (as.numeric(format(resp, '%S')) / 60 * 60)
  frac <- number / 24
  frac
}

non_hourly_frac <- function(resp, type) {
  # return to class (needed for date class)
  this_class <- class(resp)
  class(resp) <- this_class
  frac <- yrfraction(resp, type = type)
  frac
}

create_offset <- function(data, offsetpop, offsetmonth) {
  pop_offset <- rep(1, nrow(data))
  if (!is.null(offsetpop)) {
    pop_offset <- offsetpop
  }
  month_offset <- rep(1, nrow(data))
  if (offsetmonth) {
    # get the number of days in each month
    days <- flagleap(data = data, report = FALSE, matchin = TRUE)
    # days per month divided by average month length
    month_offset <- days$n_days_month / (365.25 / 12)
  }
  offset <- log(pop_offset * month_offset)
  offset
}


get_fitted_sinusoid <- function(model, newdata) {
  ## create predicted data (intercept + sinusoid)
  s <- summary(model)
  c_names <- row.names(s$coefficients)
  c_index <- sum(as.numeric(c_names == 'cosw') * (seq_along(c_names)))
  s_index <- sum(as.numeric(c_names == 'sinw') * (seq_along(c_names)))
  pred <- s$coefficients[1, 1] +
    (s$coefficients[c_index, 1] * newdata$cosw) +
    (s$coefficients[s_index, 1] * newdata$sinw)
  # back-transform:
  pred <- switch(
    s$family$link,
    log = exp(pred),
    logit = exp(pred) / (1 + exp(pred)),
    cloglog = 1 - exp(-exp(pred)),
    # default value
    pred
  )
  pred
}

add_cosw_sinw <- function(data, date, type, cycles) {
  resp <- data[[date]]
  ## get the year/hour fraction
  frac <- switch(
    type,
    hourly = hourly_frac(resp),
    # otherwise
    non_hourly_frac(resp, type)
  )

  data$cosw <- cos(frac * 2 * pi * cycles)
  data$sinw <- sin(frac * 2 * pi * cycles)
  data
}

n_days_in_year_month <- function(date) {
  # number of days per month (per year)
  n_days_month <- table(format(date, '%Y/%m'))
  year <- as.numeric(substr(names(n_days_month), 1, 4))
  month <- as.numeric(substr(names(n_days_month), 6, 7))
  days <- data.frame(
    year = year,
    month = month,
    n_days_month = as.numeric(n_days_month)
  )
  days
}

start_date <- function(year) {
  year_start <- min(year)
  # start on 1st Jan
  date_start <- as.numeric(ISOdate(year_start, 1, 1)) / (60 * 60 * 24)
  date_start
}

end_date <- function(year) {
  year_stop <- max(year)
  # stop on 31st Dec
  date_stop <- as.numeric(ISOdate(year_stop, 12, 31)) / (60 * 60 * 24)
  date_stop
}

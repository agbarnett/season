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


shorten_month_name <- function(monthvar) {
  if (max(nchar(monthvar)) == 3) {
    month_levels <- substr(month.name, 1, 3)
  } else {
    month_levels <- month.name
  }
  month_levels
}

relevel_months_by_ref <- function(monthvar, refmonth) {
  months <- as.numeric(monthvar)
  months <- as.factor(months)
  levels(months)[months] <- month.abb[months]
  # set reference month
  months <- stats::relevel(months, ref = month.abb[refmonth])
  months
}

relevel_months_by_ref_name <- function(monthvar, refmonth) {
  months_u <- as.factor(monthvar)
  # Month numbers; replaced `nochars`
  nums <- keep_month_numbers(levels(months_u))
  levels(months_u)[nums] <- month.abb[nums]
  # set reference month
  months <- stats::relevel(months_u, ref = month.abb[refmonth])
  months
}

check_var_in_data <- function(data, var) {
  var_in_data <- var %in% names(data)

  if (!var_in_data) {
    stop(
      "Data must contain a variable called '",
      var,
      "'\n",
      call. = FALSE
    )
  }
}

check_year_valid <- function(data) {
  check_var_in_data(data, "year")

  year_valid <- all(nchar(data[["year"]]) == 4)

  if (!year_valid) {
    stop(
      "The 'year' variable must have 4 digits\n",
      "See: `table(nchar(data[['year']]))`",
      call. = FALSE
    )
  }
}

day_weights <- function(data, adjmonth) {
  # get the number of days in each month
  days <- flagleap(data)

  day_wt_vec <- switch(
    adjmonth,
    none = rep(1, 12),
    thirty = 30 / days$n_days_month[1:12],
    average = (365.25 / 12) / days$n_days_month[1:12]
  )

  day_wt_vec
}


aaft_third <- function(x_diff, n.boot, n.lag, reglags) {
  # Get n.boot*3 surrogates using the AAFT method
  # First n.boot for initial limits 2nd & 3rd n.boot for bootstrap limits
  aaft_sers <- aaft(x_diff, nsur = n.boot * 3)

  # Run each series through the third order moment;

  aaft_third <- vapply(
    X = seq_len(n.boot * 3),
    FUN = function(x) {
      third(
        data = aaft_sers[, x],
        n.lag = n.lag,
        centre = FALSE,
        outmax = FALSE,
        plot = FALSE
      )$third[reglags, reglags]
    },
    FUN.VALUE = array(0, dim = c(n.lag + 1, n.lag + 1))
  )

  aaft_third[1, 1, ] <- 0 # Remove skewness;

  aaft_third
}


aaft_centile <- function(
  lower = alpha / 2,
  upper = 1 - (alpha / 2),
  n.lag = n.lag,
  aaft_third,
  third_idx
) {
  centile_l <- matrix(0, n.lag + 1, n.lag + 1)
  centile_u <- matrix(0, n.lag + 1, n.lag + 1)
  for (r in 0:n.lag) {
    for (s in r:n.lag) {
      pts <- aaft_third[r + 1, s + 1, third_idx]
      centile_l[r + 1, s + 1] <- quantile_dbl(pts, probs = lower)
      centile_u[r + 1, s + 1] <- quantile_dbl(pts, probs = upper)
    }
  }
  list(
    lower = centile_l,
    upper = centile_u
  )
}

centile_diffs <- function(upper_tri, x_third, centile) {
  # Just get for s<r;
  diff_lower <- (x_third - centile$lower) * upper_tri
  # Just get for s<r;
  diff_upper <- (x_third - centile$upper) * upper_tri

  list(
    lower = diff_lower,
    upper = diff_upper
  )
}

calculate_region <- function(n.lag, centile_diff) {
  diff_upper <- centile_diff$upper
  diff_lower <- centile_diff$lower

  # Show points significantly higher or lower than limits;
  region_upper <- matrix(0, n.lag + 1, n.lag + 1)
  region_lower <- matrix(0, n.lag + 1, n.lag + 1)
  index <- diff_upper > 0
  region_upper[index] <- diff_upper[index]
  index <- diff_lower < 0
  region_lower[index] <- diff_lower[index]
  region <- region_upper + region_lower
  region
}

jack_bootstrap <- function(n.boot, n.lag, aaft_third, centile_2) {
  jackstat <- vector(mode = 'numeric', length = n.boot)
  upper_tri <- upper.tri(matrix(0, n.lag + 1, n.lag + 1), diag = TRUE)
  for (jack in ((2 * n.boot) + 1):(n.boot * 3)) {
    ## Percentile statistic;
    diffjack_upper <- (aaft_third[,, jack] - centile_2$upper) * upper_tri
    diffjack_lower <- (aaft_third[,, jack] - centile_2$lower) * upper_tri
    jregion_upper <- matrix(0, n.lag + 1, n.lag + 1)
    jregion_lower <- matrix(0, n.lag + 1, n.lag + 1)
    jindex <- diffjack_upper > 0
    jregion_upper[jindex] <- diffjack_upper[jindex]
    jindex <- diffjack_lower < 0
    jregion_lower[jindex] <- diffjack_lower[jindex]
    jregion <- jregion_upper + jregion_lower
    # Total area exceeding limits;
    jackstat[jack - (2 * n.boot)] <- sum(sum(abs(jregion)))
  }
  jackstat
}

calc_alpha_j <- function(model, n) {
  k <- 1 # Assume just one season
  kk <- 2 * (k + 1)
  alpha_j <- matrix(0, kk, n + 1)
  ## put predictions into alpha
  # 1. trend
  alpha_j[1, 2:(n + 1)] <- stats::fitted(model)
  # 2. season
  sd_resid <- stats::sd(stats::resid(model))
  # sinusoid with amplitude equal to 10% of standard deviation of residuals
  alpha_j[3, 2:(n + 1)] <- (sd_resid / 10) * cos(2 * pi * (1:n + 1) / 12)
  alpha_j
}

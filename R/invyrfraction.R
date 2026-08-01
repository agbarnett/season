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
#' @returns the date (day and month for "daily"), fractional month (for
#'   "monthly"), or fraction of the 24-hour clock (for "hourly").
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @examples
#'
#' invyrfraction(c(0, 0.5, 0.99), type = "hourly")
#' invyrfraction(c(0, 0.5, 0.99), type = "daily")
#' invyrfraction(c(0, 0.5, 0.99), type = "weekly")
#' invyrfraction(c(0, 0.5, 0.99), type = "monthly")
#'
#' # Also provide _chr and _num functions that mean you don't specify arg,
#' # `text = TRUE` or `text = FALSE`
#' invyrfraction_num(c(0, 0.5, 0.99), type = "weekly")
#' invyrfraction_chr(c(0, 0.5, 0.99), type = "weekly")
#'
#' @export
invyrfraction <- function(
  frac,
  type = c("daily", "monthly", "hourly", "weekly"),
  text = TRUE
) {
  type <- rlang::arg_match(type)

  n <- length(frac)
  if (any(frac < 0 | frac > 1)) {
    cli::cli_abort(
      c(
        "{.arg frac} must be between {.val 0} and {.val 1}.",
        "i" = "We see a range of {.val {min(frac)}} to {.val {max(frac)}}."
      )
    )
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

#' @rdname invyrfraction
#' @export
invyrfraction_chr <- function(
  frac,
  type = c("daily", "monthly", "hourly", "weekly")
) {
  invyrfraction(
    frac = frac,
    type = type,
    text = TRUE
  )
}

#' @rdname invyrfraction
#' @export
invyrfraction_num <- function(
  frac,
  type = c("daily", "monthly", "hourly", "weekly")
) {
  invyrfraction(
    frac = frac,
    type = type,
    text = FALSE
  )
}

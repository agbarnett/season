# Aug 2014
#' Cosinor Regression Model for Detecting Seasonality in Yearly Data or
#' Circadian Patterns in Hourly Data
#'
#' Fits a cosinor model as part of a generalized linear model.
#'
#' The cosinor model captures a seasonal pattern using a sinusoid. It is
#' therefore suitable for relatively simple seasonal patterns that are
#' symmetric and stationary. The default is to fit an annual seasonal pattern
#' (`cycle`=1), but other higher frequencies are possible (e.g., twice per
#' year: `cycle`=2). The model is fitted using a sine and cosine term that
#' together describe the sinusoid. These parameters are added to a generalized
#' linear model, so the model can be fitted to a range of dependent data (e.g.,
#' Normal, Poisson, Binomial). Unlike the [nscosinor()] model, the cosinor
#' model can be applied to unequally spaced data.
#'
#' @param formula regression formula.
#' @param date a date variable if type="daily", or an integer between 1
#' and 53 if type="weekly", or an integer between 1 and 12 if
#' type="monthly", or a [POSIXct] date if type="hourly".
#' @param data data set as a data frame.
#' @param family a description of the error distribution and link function to be
#'   used in the model. Available link functions: [stats::gaussian()] (default),
#'   [identity()], [log()], `logit()`, `cloglog()`. Note, it must have the
#'   parentheses.
#' @param alpha Significance level. Default is 0.05.
#' @param cycles number of seasonal cycles per year if type="daily",
#' "weekly" or "monthly"; number of cycles per 24 hours if
#' type="hourly"
#' @param rescheck plot the residual checks (TRUE/FALSE), see
#' [seasrescheck()].
#' @param type "daily" for daily data (default), or "weekly" for
#' weekly data, or "monthly" for monthly data, or "hourly" for
#' hourly data.
#' @inheritParams monthglm
#' @param text add explanatory text to the returned phase value (TRUE) or
#' return a number (FALSE). Passed to the [invyrfraction()] function.
#' @returns Returns an object of class "Cosinor" with the following
#' parts:
#'   * call: the original call to the cosinor function.
#'   * glm: an object of class `glm` (see [glm()]).
#'   * fitted: fitted values for intercept and cosinor only (ignoring other
#'     independent variables).
#'   * fitted.plus: standard fitted values, including all other independent
#'     variables.
#'   * residuals: residuals.
#'   * date: name of the date variable (in Date format when type = `daily`).
#' @author Adrian Barnett \email{a.barnett@qut.edu.au}
#' @seealso [summary.Cosinor()], [plot.Cosinor()]
#' @references Barnett, A.G., Dobson, A.J. (2010) *Analysing Seasonal
#' Health Data*. Springer. \doi{doi:10.1007/978-3-642-10748-1}
#' @examples
#' ## cardiovascular disease data (offset based on number of days in...
#' ## ...the month scaled to an average month length)
#' res <- cosinor(
#'   cvd ~ 1,
#'   date = 'month',
#'   data = CVD,
#'   type = 'monthly',
#'   family = poisson(),
#'   offsetmonth = TRUE
#' )
#' summary(res)
#' seasrescheck(res$residuals) # check the residuals
#' ## stillbirth data
#' res <- cosinor(
#'   stillborn ~ 1,
#'   date = 'dob',
#'   data = stillbirth,
#'   family = binomial(link = 'cloglog')
#' )
#' summary(res)
#' plot(res)
#' ## hourly indoor temperature data
#' res <- cosinor(bedroom ~ 1, date = 'datetime', type = 'hourly', data = indoor)
#' summary(res)
#' # to get the p-values for the sine and cosine estimates
#' summary(res$glm)
#'
#' @export cosinor
cosinor <- function(
  formula,
  date,
  data,
  family = stats::gaussian(),
  alpha = 0.05,
  cycles = 1,
  rescheck = FALSE,
  type = c("daily", "weekly", "monthly", "hourly"),
  offsetmonth = FALSE,
  offsetpop = NULL,
  text = TRUE
) {
  type <- rlang::arg_match(type)

  if (!is.logical(offsetmonth)) {
    stop("Error: 'offsetmonth' must be of type logical")
  }
  if (type == 'hourly' && !inherits(data[[date]], "POSIXct")) {
    stop("date variable must be of class POSIXct when type = 'hourly'")
  }
  if (type == 'daily' && !inherits(data[[date]], 'Date')) {
    stop("date variable must be of class Date when type = 'daily'")
  }
  if (alpha <= 0 || alpha >= 1) {
    stop("alpha must be between 0 and 1")
  }
  if (type == 'hourly' && offsetmonth) {
    stop("do not use monthly offset for hourly data")
  }

  ## original call with defaults (see amer package)
  link <- family$link
  ans <- as.list(match.call())
  frmls <- formals(deparse(ans[[1]]))
  add <- which(!(names(frmls) %in% names(ans)))
  call <- as.call(c(ans, frmls[add], link = link))

  ## make the formula
  parts <- paste(formula)
  form <- stats::as.formula(paste(
    parts[2],
    parts[1],
    parts[3:length(formula)],
    '+cosw+sinw'
  ))

  ## get the year/hour fraction
  to_frac <- subset(data, select = date)[, 1]
  if (type == 'hourly') {
    number <- as.numeric(format(to_frac, '%H')) +
      (as.numeric(format(to_frac, '%M')) / 60) +
      (as.numeric(format(to_frac, '%S')) / 60 * 60)
    frac <- number / 24
  }
  this_class <- class(data[[date]])
  if (type != 'hourly') {
    # return to class (needed for date class)
    class(to_frac) <- this_class
    frac <- yrfraction(to_frac, type = type) #
  }
  data$cosw <- cos(frac * 2 * pi * cycles)
  data$sinw <- sin(frac * 2 * pi * cycles)
  # used later
  newdata <- data.frame(cosw = data$cosw, sinw = data$sinw)
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
  # generalized linear model
  model <- stats::glm(form, data = data, family = family, offset = offset)
  s <- summary(model)
  res <- stats::residuals(model)

  ## create predicted data (intercept + sinusoid)
  c_names <- row.names(s$coefficients)
  c_index <- sum(as.numeric(c_names == 'cosw') * (seq_along(c_names)))
  s_index <- sum(as.numeric(c_names == 'sinw') * (seq_along(c_names)))
  fitted <- stats::fitted(model) # standard fitted values
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

  # return:
  ret <- list(
    call = call,
    # changed to model rather than summary
    glm = model,
    fitted.plus = fitted,
    fitted.values = pred,
    residuals = res,
    date = date,
    type = type
  )
  class(ret) <- 'Cosinor'

  ret
}

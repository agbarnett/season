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
#' res <- cosinor(
#'   bedroom ~ 1,
#'   date = 'datetime',
#'   type = 'hourly',
#'   data = indoor
#' )
#'
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

  check_if_logical(offsetmonth)
  check_if_hourly_posixct(type, data[[date]])
  check_if_daily_date(type, data[[date]])
  check_if_btn_0_1(alpha)
  if (type == 'hourly' && offsetmonth) {
    stop("do not use monthly offset for hourly data")
  }

  ## original call with defaults (see amer package)
  call <- match_call_with_defaults(match.call(), sys.function())
  call$link <- family$link

  data <- add_cosw_sinw(data, date, type, cycles)

  offset <- create_offset(data, offsetpop, offsetmonth)

  form <- append_terms_to_formula(formula, "cosw + sinw")

  model <- stats::glm(form, data = data, family = family, offset = offset)

  res <- stats::residuals(model)
  fitted <- stats::fitted(model)

  newdata <- data.frame(cosw = data$cosw, sinw = data$sinw)
  pred <- get_fitted_sinusoid(model, newdata)

  results <- list(
    call = call,
    glm = model,
    fitted.plus = fitted,
    fitted.values = pred,
    residuals = res,
    date = date,
    type = type
  )
  class(results) <- c('Cosinor', class(results))

  results
}
